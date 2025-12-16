"""
Load data ke database (staging, dimension, fact tables)
"""
import pandas as pd
from sqlalchemy import text
from config import Config, logger
from utils import log_etl_step


class DataLoader:
    """Class untuk load data ke database"""
    
    def __init__(self):
        self.engine = Config.get_engine()
    
    def load_to_staging(self, df, table_name='staging_kunjungan_raw'):
        """
        Load data ke staging table
        REVISED: Load RAW data without transformation
        """
        try:
            log_etl_step("LOAD", "START", f"Loading to {table_name}")
            
            # Load data using pandas to_sql
            df.to_sql(
                table_name,
                self.engine,
                if_exists='append',
                index=False,
                method='multi',
                chunksize=1000
            )
            
            log_etl_step("LOAD", "SUCCESS", f"Loaded {len(df)} records to {table_name}")
            
        except Exception as e:
            log_etl_step("LOAD", "ERROR", str(e))
            raise
    
    def load_dim_time(self, df):
        """
        Load data ke dim_time dengan handling duplicates
        REVISED: Use 'periode' column from transformed data
        """
        try:
            log_etl_step("LOAD", "START", "Loading to dim_time")
            
            with self.engine.begin() as conn:
                inserted = 0
                for _, row in df.iterrows():
                    try:
                        query = text("""
                            INSERT INTO dim_time (periode, bulan, tahun, kuartal)
                            VALUES (:periode, :bulan, :tahun, :kuartal)
                            ON CONFLICT (periode) DO NOTHING
                        """)
                        
                        result = conn.execute(query, {
                            'periode': row['periode'],
                            'bulan': row['bulan'],
                            'tahun': row['tahun'],
                            'kuartal': row['kuartal']
                        })
                        
                        if result.rowcount > 0:
                            inserted += 1
                            
                    except Exception as e:
                        logger.warning(f"Error inserting time record: {e}")
                        continue
            
            log_etl_step("LOAD", "SUCCESS", f"Inserted {inserted} new time records")
            
        except Exception as e:
            log_etl_step("LOAD", "ERROR", str(e))
            raise
    
    def load_dim_objek_wisata(self, df):
        """
        Load data ke dim_objek_wisata dengan handling duplicates
        """
        try:
            log_etl_step("LOAD", "START", "Loading to dim_objek_wisata")
            
            with self.engine.begin() as conn:
                inserted = 0
                for _, row in df.iterrows():
                    try:
                        # Check if exists
                        check_query = text("""
                            SELECT objek_wisata_id FROM dim_objek_wisata 
                            WHERE nama_objek = :nama_objek
                        """)
                        
                        exists = conn.execute(check_query, {
                            'nama_objek': row['nama_objek']
                        }).fetchone()
                        
                        if not exists:
                            insert_query = text("""
                                INSERT INTO dim_objek_wisata 
                                (nama_objek, alamat, longitude, latitude, wilayah)
                                VALUES (:nama_objek, :alamat, :longitude, :latitude, :wilayah)
                            """)
                            
                            conn.execute(insert_query, {
                                'nama_objek': row['nama_objek'],
                                'alamat': row['alamat'],
                                'longitude': row['longitude'],
                                'latitude': row['latitude'],
                                'wilayah': row['wilayah']
                            })
                            inserted += 1
                            
                    except Exception as e:
                        logger.warning(f"Error inserting objek wisata: {e}")
                        continue
            
            log_etl_step("LOAD", "SUCCESS", f"Inserted {inserted} new objek wisata records")
            
        except Exception as e:
            log_etl_step("LOAD", "ERROR", str(e))
            raise
    
    def load_dim_price(self, df_price, truncate=True):
        """
        Load data ke dim_price (struktur sederhana - tanpa pembedaan WNI/WNA)
        
        Args:
            df_price: DataFrame dengan kolom:
                - objek_wisata_id
                - harga_tiket_dewasa
                - harga_tiket_anak
                - mata_uang
                - sumber_platform (optional)
                - tanggal_update (optional)
            truncate: Boolean, truncate table sebelum insert (default: True)
        
        Returns:
            int: Jumlah records yang di-insert/update
        """
        try:
            log_etl_step("LOAD", "START", "Loading to dim_price")
            
            with self.engine.begin() as conn:
                # Truncate jika diminta
                if truncate:
                    log_etl_step("LOAD", "INFO", "Truncating dim_price table")
                    conn.execute(text("TRUNCATE TABLE dim_price RESTART IDENTITY CASCADE"))
                
                inserted = 0
                updated = 0
                
                for _, row in df_price.iterrows():
                    try:
                        # Check if price exists for this objek_wisata
                        check_query = text("""
                            SELECT price_id FROM dim_price 
                            WHERE objek_wisata_id = :objek_wisata_id
                        """)
                        
                        exists = conn.execute(check_query, {
                            'objek_wisata_id': int(row['objek_wisata_id'])
                        }).fetchone()
                        
                        # Prepare base data
                        data = {
                            'objek_wisata_id': int(row['objek_wisata_id']),
                            'harga_tiket_dewasa': int(row['harga_tiket_dewasa']),
                            'harga_tiket_anak': int(row['harga_tiket_anak']),
                            'mata_uang': row['mata_uang']
                        }
                        
                        # Add optional columns if they exist
                        if 'sumber_platform' in row.index and pd.notna(row['sumber_platform']):
                            data['sumber_platform'] = row['sumber_platform']
                        
                        if 'tanggal_update' in row.index and pd.notna(row['tanggal_update']):
                            data['tanggal_update'] = row['tanggal_update']
                        
                        if not exists:
                            # Insert new price
                            cols = ', '.join(data.keys())
                            placeholders = ', '.join([f':{k}' for k in data.keys()])
                            insert_query = text(f"""
                                INSERT INTO dim_price ({cols})
                                VALUES ({placeholders})
                            """)
                            
                            conn.execute(insert_query, data)
                            inserted += 1
                        else:
                            # Update existing price
                            set_clause = ', '.join([f'{k} = :{k}' for k in data.keys() if k != 'objek_wisata_id'])
                            update_query = text(f"""
                                UPDATE dim_price SET {set_clause}
                                WHERE objek_wisata_id = :objek_wisata_id
                            """)
                            
                            conn.execute(update_query, data)
                            updated += 1
                            
                    except Exception as e:
                        logger.warning(f"Error loading price for objek_wisata_id {row['objek_wisata_id']}: {e}")
                        continue
            
            total_affected = inserted + updated
            log_etl_step("LOAD", "INFO", f"Inserted: {inserted}, Updated: {updated}")
            log_etl_step("LOAD", "SUCCESS", f"Loaded {total_affected} price records to dim_price")
            
            # Verify loaded data
            with self.engine.connect() as conn:
                result = conn.execute(text("SELECT COUNT(*) FROM dim_price"))
                count = result.scalar()
                log_etl_step("LOAD", "INFO", f"Total records in dim_price: {count}")
            
            return total_affected
            
        except Exception as e:
            log_etl_step("LOAD", "ERROR", str(e))
            raise
    
    def load_fact_kunjungan(self):
        """
        Load data ke fact_kunjungan dari staging RAW
        FIXED: Handle JOIN issues dengan proper casting dan TRIM
        """
        try:
            log_etl_step("LOAD", "START", "Loading to fact_kunjungan")
            
            with self.engine.begin() as conn:
                # DEBUG: Check counts before insert
                staging_count_query = text("""
                    SELECT 
                        COUNT(*) as total,
                        COUNT(DISTINCT periode_data) as unique_periode,
                        COUNT(DISTINCT obyek_wisata) as unique_objek,
                        COUNT(DISTINCT jenis_wisatawan) as unique_wisatawan
                    FROM staging_kunjungan_raw 
                    WHERE is_processed = FALSE
                """)
                
                result = conn.execute(staging_count_query)
                staging_stats = result.fetchone()
                log_etl_step("LOAD", "INFO", f"Staging stats: {staging_stats[0]} total, {staging_stats[1]} periodes, {staging_stats[2]} objek, {staging_stats[3]} wisatawan")
                
                # DEBUG: Check dimension counts
                dim_counts = {}
                for table in ['dim_time', 'dim_objek_wisata', 'dim_wisatawan']:
                    result = conn.execute(text(f"SELECT COUNT(*) FROM {table}"))
                    dim_counts[table] = result.scalar()
                    log_etl_step("LOAD", "INFO", f"{table}: {dim_counts[table]} records")
                
                # FIXED: Insert query dengan proper JOIN conditions
                query = text("""
                    INSERT INTO fact_kunjungan (
                        time_id, objek_wisata_id, wisatawan_id, jumlah_kunjungan
                    )
                    SELECT DISTINCT
                        dt.time_id,
                        dobj.objek_wisata_id,
                        dw.wisatawan_id,
                        COALESCE(s.jumlah_kunjungan, 0) AS jumlah_kunjungan
                    FROM staging_kunjungan_raw s
                    INNER JOIN dim_time dt 
                        ON TRIM(dt.periode) = TRIM(s.periode_data::VARCHAR)
                    INNER JOIN dim_objek_wisata dobj 
                        ON LOWER(TRIM(dobj.nama_objek)) = LOWER(TRIM(s.obyek_wisata))
                    INNER JOIN dim_wisatawan dw 
                        ON LOWER(TRIM(dw.jenis_wisatawan)) = LOWER(TRIM(s.jenis_wisatawan))
                    WHERE s.is_processed = FALSE
                        AND s.periode_data IS NOT NULL
                        AND s.obyek_wisata IS NOT NULL
                        AND s.jenis_wisatawan IS NOT NULL
                    ON CONFLICT (time_id, objek_wisata_id, wisatawan_id) 
                    DO UPDATE SET 
                        jumlah_kunjungan = EXCLUDED.jumlah_kunjungan,
                        updated_at = CURRENT_TIMESTAMP
                """)
                
                result = conn.execute(query)
                rows_affected = result.rowcount
                
                log_etl_step("LOAD", "INFO", f"Inserted/Updated {rows_affected} fact records")
                
                # DEBUG: Check if any rows were not joined
                unmatched_query = text("""
                    SELECT 
                        COUNT(*) as unmatched,
                        COUNT(DISTINCT s.periode_data) as unmatched_periode,
                        COUNT(DISTINCT s.obyek_wisata) as unmatched_objek,
                        COUNT(DISTINCT s.jenis_wisatawan) as unmatched_wisatawan
                    FROM staging_kunjungan_raw s
                    LEFT JOIN dim_time dt ON TRIM(dt.periode) = TRIM(s.periode_data::VARCHAR)
                    LEFT JOIN dim_objek_wisata dobj ON LOWER(TRIM(dobj.nama_objek)) = LOWER(TRIM(s.obyek_wisata))
                    LEFT JOIN dim_wisatawan dw ON LOWER(TRIM(dw.jenis_wisatawan)) = LOWER(TRIM(s.jenis_wisatawan))
                    WHERE s.is_processed = FALSE
                        AND (dt.time_id IS NULL OR dobj.objek_wisata_id IS NULL OR dw.wisatawan_id IS NULL)
                """)
                
                result = conn.execute(unmatched_query)
                unmatched = result.fetchone()
                if unmatched[0] > 0:
                    log_etl_step("LOAD", "WARNING", f"Found {unmatched[0]} unmatched staging records!")
                    log_etl_step("LOAD", "WARNING", f"  - Unmatched periodes: {unmatched[1]}")
                    log_etl_step("LOAD", "WARNING", f"  - Unmatched objek: {unmatched[2]}")
                    log_etl_step("LOAD", "WARNING", f"  - Unmatched wisatawan: {unmatched[3]}")
                    
                    # Show sample unmatched records
                    sample_query = text("""
                        SELECT 
                            s.periode_data,
                            s.obyek_wisata,
                            s.jenis_wisatawan,
                            CASE WHEN dt.time_id IS NULL THEN 'MISSING' ELSE 'OK' END as time_match,
                            CASE WHEN dobj.objek_wisata_id IS NULL THEN 'MISSING' ELSE 'OK' END as objek_match,
                            CASE WHEN dw.wisatawan_id IS NULL THEN 'MISSING' ELSE 'OK' END as wisatawan_match
                        FROM staging_kunjungan_raw s
                        LEFT JOIN dim_time dt ON TRIM(dt.periode) = TRIM(s.periode_data::VARCHAR)
                        LEFT JOIN dim_objek_wisata dobj ON LOWER(TRIM(dobj.nama_objek)) = LOWER(TRIM(s.obyek_wisata))
                        LEFT JOIN dim_wisatawan dw ON LOWER(TRIM(dw.jenis_wisatawan)) = LOWER(TRIM(s.jenis_wisatawan))
                        WHERE s.is_processed = FALSE
                            AND (dt.time_id IS NULL OR dobj.objek_wisata_id IS NULL OR dw.wisatawan_id IS NULL)
                        LIMIT 5
                    """)
                    
                    result = conn.execute(sample_query)
                    samples = result.fetchall()
                    for sample in samples:
                        log_etl_step("LOAD", "WARNING", f"  Sample: {sample}")
                
                # Mark staging as processed
                update_query = text("""
                    UPDATE staging_kunjungan_raw 
                    SET 
                        is_processed = TRUE,
                        processed_at = CURRENT_TIMESTAMP
                    WHERE is_processed = FALSE
                """)
                conn.execute(update_query)
            
            log_etl_step("LOAD", "SUCCESS", f"Loaded {rows_affected} fact records")
            log_etl_step("LOAD", "INFO", "Staging records marked as processed")
            
            # Verify final count
            with self.engine.connect() as conn:
                result = conn.execute(text("SELECT COUNT(*) FROM fact_kunjungan"))
                total = result.scalar()
                log_etl_step("LOAD", "INFO", f"Total fact_kunjungan records: {total}")
            
        except Exception as e:
            log_etl_step("LOAD", "ERROR", str(e))
            import traceback
            traceback.print_exc()
            raise

    def truncate_staging(self):
        """
        Clean staging tables
        """
        try:
            log_etl_step("LOAD", "START", "Truncating staging tables")
            
            with self.engine.begin() as conn:
                conn.execute(text("TRUNCATE TABLE staging_kunjungan_raw RESTART IDENTITY CASCADE"))
                conn.execute(text("TRUNCATE TABLE staging_harga_tiket_raw RESTART IDENTITY CASCADE"))
            
            log_etl_step("LOAD", "SUCCESS", "Staging tables truncated")
            
        except Exception as e:
            log_etl_step("LOAD", "WARNING", f"Failed to truncate staging: {e}")
    
    def verify_data_quality(self):
        """
        Verify data quality across tables
        Returns: dict with verification results
        """
        try:
            log_etl_step("LOAD", "START", "Verifying data quality")
            
            results = {}
            
            with self.engine.connect() as conn:
                # Check dim_time
                result = conn.execute(text("SELECT COUNT(*) FROM dim_time"))
                results['dim_time'] = result.scalar()
                
                # Check dim_objek_wisata
                result = conn.execute(text("SELECT COUNT(*) FROM dim_objek_wisata"))
                results['dim_objek_wisata'] = result.scalar()
                
                # Check dim_wisatawan
                result = conn.execute(text("SELECT COUNT(*) FROM dim_wisatawan"))
                results['dim_wisatawan'] = result.scalar()
                
                # Check dim_price
                result = conn.execute(text("SELECT COUNT(*) FROM dim_price"))
                results['dim_price'] = result.scalar()
                
                # Check fact_kunjungan
                result = conn.execute(text("SELECT COUNT(*) FROM fact_kunjungan"))
                results['fact_kunjungan'] = result.scalar()
                
                # Check staging processed status
                result = conn.execute(text("""
                    SELECT 
                        COUNT(*) as total,
                        SUM(CASE WHEN is_processed = TRUE THEN 1 ELSE 0 END) as processed,
                        SUM(CASE WHEN is_processed = FALSE THEN 1 ELSE 0 END) as unprocessed
                    FROM staging_kunjungan_raw
                """))
                staging_status = result.fetchone()
                if staging_status:
                    results['staging_total'] = staging_status[0]
                    results['staging_processed'] = staging_status[1]
                    results['staging_unprocessed'] = staging_status[2]
                
                # Check orphan records in fact
                result = conn.execute(text("""
                    SELECT COUNT(*) FROM fact_kunjungan f
                    LEFT JOIN dim_time dt ON f.time_id = dt.time_id
                    LEFT JOIN dim_objek_wisata dobj ON f.objek_wisata_id = dobj.objek_wisata_id
                    LEFT JOIN dim_wisatawan dw ON f.wisatawan_id = dw.wisatawan_id
                    WHERE dt.time_id IS NULL 
                       OR dobj.objek_wisata_id IS NULL 
                       OR dw.wisatawan_id IS NULL
                """))
                results['orphan_facts'] = result.scalar()
            
            log_etl_step("LOAD", "INFO", "Data quality verification:")
            for table, count in results.items():
                log_etl_step("LOAD", "INFO", f"  - {table}: {count} records")
            
            if results['orphan_facts'] > 0:
                log_etl_step("LOAD", "WARNING", f"Found {results['orphan_facts']} orphan fact records!")
            else:
                log_etl_step("LOAD", "SUCCESS", "No orphan records found")
            
            return results
            
        except Exception as e:
            log_etl_step("LOAD", "ERROR", f"Verification failed: {e}")
            return None


if __name__ == "__main__":
    print("="*80)
    print("Testing DataLoader Module")
    print("="*80)
    
    loader = DataLoader()
    
    # Test verify data quality
    print("\nVerifying data quality...")
    results = loader.verify_data_quality()
    
    if results:
        print("\nData Quality Summary:")
        print("="*80)
        for table, count in results.items():
            status = "✓" if count > 0 or (table == 'orphan_facts' and count == 0) else "✗"
            print(f"{status} {table:30s}: {count:,} records")
        print("="*80)
    
    print("\nLoad module ready. Use main_etl.py to run full ETL process.")
