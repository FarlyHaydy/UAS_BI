"""
Transform dan cleaning data
Traditional ETL: Transform FROM staging database
"""
import pandas as pd
import numpy as np
from config import Config, logger
from utils import (
    log_etl_step, 
    clean_text, 
    extract_periode_info,
    extract_wilayah_from_alamat
)





class DataTransformer:
    """Class untuk transform dan cleaning data"""
    
    def __init__(self):
        self.engine = Config.get_engine()
    
    def transform_harga_data(self, df_harga):
        """
        Transform data harga tiket untuk dim_price
        
        Args:
            df_harga: DataFrame dengan kolom RAW dari Excel:
                - nama_objek_wisata, harga_tiket_dewasa, harga_tiket_anak, gratis, mata_uang
        
        Returns:
            DataFrame dengan kolom untuk dim_price
        """
        try:
            log_etl_step("TRANSFORM", "START", "Transforming harga data")
            
            # 1. Get objek wisata mapping from database
            query_objek = "SELECT objek_wisata_id, nama_objek FROM dim_objek_wisata"
            df_objek = pd.read_sql(query_objek, self.engine)
            
            log_etl_step("TRANSFORM", "INFO", f"Found {len(df_objek)} objek wisata in database")
            
            # 2. Clean nama_objek_wisata in harga data
            df_harga_clean = df_harga.copy()
            df_harga_clean['nama_objek_wisata'] = df_harga_clean['nama_objek_wisata'].apply(clean_text)
            
            # 3. Clean nama_objek in dim_objek_wisata for matching
            df_objek['nama_objek'] = df_objek['nama_objek'].apply(clean_text)
            
            # 4. Merge with dim_objek_wisata
            df_merged = df_harga_clean.merge(
                df_objek,
                left_on='nama_objek_wisata',
                right_on='nama_objek',
                how='left'
            )
            
            # 5. Check unmapped records
            unmapped = df_merged[df_merged['objek_wisata_id'].isna()]
            if not unmapped.empty:
                log_etl_step("TRANSFORM", "WARNING", 
                    f"{len(unmapped)} harga records without matching objek wisata:")
                for name in unmapped['nama_objek_wisata'].tolist():
                    logger.warning(f"  - {name}")
            
            # 6. Filter only mapped records
            df_mapped = df_merged[df_merged['objek_wisata_id'].notna()].copy()
            
            # 7. Handle gratis flag (set to 0 if gratis)
            if 'gratis' in df_mapped.columns:
                gratis_mask = df_mapped['gratis'].str.lower() == 'ya'
                df_mapped.loc[gratis_mask, 'harga_tiket_dewasa'] = 0
                df_mapped.loc[gratis_mask, 'harga_tiket_anak'] = 0
            
            # 8. Select columns
            columns_to_keep = [
                'objek_wisata_id',
                'harga_tiket_dewasa',
                'harga_tiket_anak',
                'mata_uang'
            ]
            
            if 'sumber_platform' in df_mapped.columns:
                columns_to_keep.append('sumber_platform')
            
            if 'tanggal_update' in df_mapped.columns:
                columns_to_keep.append('tanggal_update')
            
            df_final = df_mapped[columns_to_keep].copy()
            
            # 9. Convert to proper data types
            df_final['objek_wisata_id'] = df_final['objek_wisata_id'].astype(int)
            df_final['harga_tiket_dewasa'] = df_final['harga_tiket_dewasa'].fillna(0).astype(int)
            df_final['harga_tiket_anak'] = df_final['harga_tiket_anak'].fillna(0).astype(int)
            
            if 'tanggal_update' in df_final.columns:
                df_final['tanggal_update'] = pd.to_datetime(df_final['tanggal_update']).dt.date
            
            # 10. Remove duplicates
            df_final = df_final.drop_duplicates(subset=['objek_wisata_id'], keep='first')
            
            # 11. Log statistics
            gratis_count = (df_final['harga_tiket_dewasa'] == 0).sum()
            berbayar_count = len(df_final) - gratis_count
            
            log_etl_step("TRANSFORM", "INFO", f"Harga data statistics:")
            log_etl_step("TRANSFORM", "INFO", f"  - Total: {len(df_final)}, Gratis: {gratis_count}, Berbayar: {berbayar_count}")
            
            if berbayar_count > 0:
                df_berbayar = df_final[df_final['harga_tiket_dewasa'] > 0]
                avg_price = df_berbayar['harga_tiket_dewasa'].mean()
                log_etl_step("TRANSFORM", "INFO", f"  - Average price: Rp {avg_price:,.0f}")
            
            log_etl_step("TRANSFORM", "SUCCESS", f"Transformed {len(df_final)} harga records")
            
            return df_final
            
        except Exception as e:
            log_etl_step("TRANSFORM", "ERROR", str(e))
            raise
    
    
    def build_dim_time(self):
        """
        Build dim_time FROM staging database (Traditional ETL)
        
        Returns:
            DataFrame with columns: periode, bulan, tahun, kuartal
        """
        try:
            log_etl_step("TRANSFORM", "START", "Building dim_time FROM staging")
            
            query = """
                SELECT DISTINCT periode_data 
                FROM staging_kunjungan_raw 
                WHERE is_processed = FALSE
            """
            df_periode = pd.read_sql(query, self.engine)
            
            if df_periode.empty:
                log_etl_step("TRANSFORM", "WARNING", "No unprocessed data in staging")
                return pd.DataFrame(columns=['periode', 'bulan', 'tahun', 'kuartal'])
            
            dim_time_data = []
            
            for periode in df_periode['periode_data']:
                periode_info = extract_periode_info(str(periode))
                if periode_info:
                    dim_time_data.append({
                        'periode': str(periode),
                        'bulan': periode_info['bulan'],
                        'tahun': periode_info['tahun'],
                        'kuartal': periode_info['kuartal']
                    })
            
            df_dim_time = pd.DataFrame(dim_time_data)
            df_dim_time = df_dim_time.drop_duplicates(subset=['periode'])
            
            log_etl_step("TRANSFORM", "SUCCESS", f"Built {len(df_dim_time)} time records FROM staging")
            
            return df_dim_time
            
        except Exception as e:
            log_etl_step("TRANSFORM", "ERROR", str(e))
            raise
    
    def build_dim_objek_wisata(self):
        """
        Build dim_objek_wisata FROM staging database 
        
        Returns:
            DataFrame with columns: nama_objek, wilayah, alamat, longitude, latitude
        """
        try:
            log_etl_step("TRANSFORM", "START", "Building dim_objek_wisata FROM staging")
            
            query = """
                SELECT DISTINCT 
                    obyek_wisata,
                    alamat,
                    longitude,
                    latitude
                FROM staging_kunjungan_raw 
                WHERE is_processed = FALSE
            """
            df_objek = pd.read_sql(query, self.engine)
            
            if df_objek.empty:
                log_etl_step("TRANSFORM", "WARNING", "No unprocessed data in staging")
                return pd.DataFrame(columns=['nama_objek', 'wilayah', 'alamat', 'longitude', 'latitude'])
            
            # Extract wilayah from alamat
            df_objek['wilayah'] = df_objek['alamat'].apply(extract_wilayah_from_alamat)
            
            # Rename column
            df_objek = df_objek.rename(columns={'obyek_wisata': 'nama_objek'})
            
            # Clean text
            df_objek['nama_objek'] = df_objek['nama_objek'].apply(clean_text)
            df_objek['alamat'] = df_objek['alamat'].apply(clean_text)
            
            # Remove duplicates
            df_objek = df_objek.drop_duplicates(subset=['nama_objek'])
            
            log_etl_step("TRANSFORM", "SUCCESS", f"Built {len(df_objek)} objek wisata FROM staging")
            
            return df_objek[['nama_objek', 'wilayah', 'alamat', 'longitude', 'latitude']]
            
        except Exception as e:
            log_etl_step("TRANSFORM", "ERROR", str(e))
            raise





if __name__ == "__main__":
    # Test transformation
    from extract import DataExtractor
    
    print("="*80)
    print("TEST: Build Dimensions FROM Staging (Traditional ETL)")
    print("="*80)
    
    transformer = DataTransformer()
    
    print("\n[1/2] Building dim_time FROM staging...")
    try:
        df_dim_time = transformer.build_dim_time()
        print(df_dim_time.head(10))
        print(f"Total time records: {len(df_dim_time)}")
    except Exception as e:
        print(f"Error: {e}")
        print("Note: Make sure staging table has unprocessed data")
    
    print("\n" + "="*80)
    print("[2/2] Building dim_objek_wisata FROM staging...")
    try:
        df_dim_objek = transformer.build_dim_objek_wisata()
        print(df_dim_objek.head(10))
        print(f"Total objek wisata: {len(df_dim_objek)}")
    except Exception as e:
        print(f"Error: {e}")
        print("Note: Make sure staging table has unprocessed data")
    
    print("\n" + "="*80)
    print("TEST: Transform Harga Data")
    print("="*80)
    
    extractor = DataExtractor()
    df_harga = extractor.extract_harga_data()
    
    if df_harga is not None:
        df_harga_transformed = transformer.transform_harga_data(df_harga)
        
        print("\nTransformed harga data:")
        print(df_harga_transformed.head(10))
        print(f"Total records: {len(df_harga_transformed)}")
        
        # Show price distribution
        print("\nPrice Distribution:")
        print(df_harga_transformed[['objek_wisata_id', 'harga_tiket_dewasa', 'harga_tiket_anak']].to_string(index=False))
    else:
        print("Harga data not available")
    
    print("\n" + "="*80)
    print("Transform module ready for traditional ETL pipeline")
    print("="*80)
