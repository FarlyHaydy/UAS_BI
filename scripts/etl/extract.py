"""
Extract data from source files (Excel, XLSX)
"""
import pandas as pd
import os
from config import KUNJUNGAN_DATA_PATH, EXCEL_FILE, HARGA_DATA_PATH, HARGA_FILE, logger
from utils import log_etl_step, validate_data_quality


class DataExtractor:
    """Class untuk extract data dari berbagai sumber"""
    
    def __init__(self):
        self.kunjungan_path = KUNJUNGAN_DATA_PATH
        self.harga_path = HARGA_DATA_PATH
    
    def extract_kunjungan_data(self):
        """
        Extract data kunjungan dari Excel (portal_satu_data)
        Returns: DataFrame
        """
        try:
            log_etl_step("EXTRACT", "START", "Reading kunjungan data from Excel")
            
            # Path ke file kunjungan di portal_satu_data
            file_path = os.path.join(self.kunjungan_path, EXCEL_FILE)
            
            if not os.path.exists(file_path):
                raise FileNotFoundError(f"File not found: {file_path}")
            
            # Read Excel file
            df = pd.read_excel(file_path, sheet_name='Sheet1')
            
            log_etl_step("EXTRACT", "INFO", f"Read {len(df)} rows from Excel")
            
            # Validate data
            required_columns = [
                'periode_data', 'obyek_wisata', 'alamat', 
                'longitude', 'latitude', 'jenis_wisatawan', 'jumlah_kunjungan'
            ]
            
            is_valid, errors = validate_data_quality(df, required_columns)
            if not is_valid:
                raise ValueError(f"Data validation failed: {errors}")
            
            log_etl_step("EXTRACT", "SUCCESS", f"Extracted {len(df)} records")
            
            return df
            
        except Exception as e:
            log_etl_step("EXTRACT", "ERROR", str(e))
            raise
    
    def extract_harga_data(self):
        """
        Extract data harga tiket dari Excel (manual_collection)
        Returns: DataFrame atau None jika file tidak ada
        
        File structure:
        - nama_objek_wisata: Nama objek wisata
        - harga_tiket_dewasa: Harga tiket untuk dewasa
        - harga_tiket_anak: Harga tiket untuk anak
        - gratis: Ya/Tidak
        - mata_uang: IDR, USD, dll
        - sumber_platform: Sumber data (Website Resmi, Survey Manual, dll)
        - tanggal_update: Tanggal terakhir update data
        """
        try:
            log_etl_step("EXTRACT", "START", "Reading harga tiket data")
            
            # Path ke file harga di manual_collection
            file_path = os.path.join(self.harga_path, HARGA_FILE)
            
            if not os.path.exists(file_path):
                log_etl_step("EXTRACT", "WARNING", f"Harga file not found: {file_path}")
                return None
            
            # Read Excel file
            df = pd.read_excel(file_path)
            
            log_etl_step("EXTRACT", "INFO", f"Read {len(df)} harga records from Excel")
            
            # Validate required columns
            required_columns = [
                'nama_objek_wisata',
                'harga_tiket_dewasa',
                'harga_tiket_anak',
                'mata_uang'
            ]
            
            is_valid, errors = validate_data_quality(df, required_columns)
            if not is_valid:
                log_etl_step("EXTRACT", "WARNING", f"Harga data validation failed: {errors}")
                return None
            
            # Log data statistics
            gratis_count = df[df['gratis'] == 'Ya'].shape[0] if 'gratis' in df.columns else 0
            berbayar_count = len(df) - gratis_count
            
            log_etl_step("EXTRACT", "INFO", f"Harga data breakdown:")
            log_etl_step("EXTRACT", "INFO", f"  - Objek wisata gratis: {gratis_count}")
            log_etl_step("EXTRACT", "INFO", f"  - Objek wisata berbayar: {berbayar_count}")
            
            # Log price range
            if berbayar_count > 0:
                df_berbayar = df[df['harga_tiket_dewasa'] > 0]
                min_price = df_berbayar['harga_tiket_dewasa'].min()
                max_price = df_berbayar['harga_tiket_dewasa'].max()
                avg_price = df_berbayar['harga_tiket_dewasa'].mean()
                
                log_etl_step("EXTRACT", "INFO", f"  - Harga tiket dewasa range: Rp {min_price:,.0f} - Rp {max_price:,.0f}")
                log_etl_step("EXTRACT", "INFO", f"  - Harga tiket dewasa rata-rata: Rp {avg_price:,.0f}")
            
            log_etl_step("EXTRACT", "SUCCESS", f"Extracted {len(df)} harga records")
            
            return df
            
        except Exception as e:
            log_etl_step("EXTRACT", "WARNING", f"Harga data not available: {e}")
            return None


if __name__ == "__main__":
    # Test extraction
    extractor = DataExtractor()
    
    print("="*80)
    print("Testing Kunjungan Data Extraction")
    print("="*80)
    
    try:
        df_kunjungan = extractor.extract_kunjungan_data()
        print(df_kunjungan.head())
        print(f"\nTotal rows: {len(df_kunjungan)}")
        print(f"Columns: {df_kunjungan.columns.tolist()}")
        print(f"\nData types:")
        print(df_kunjungan.dtypes)
    except Exception as e:
        print(f"Error: {e}")
    
    print("\n" + "="*80)
    print("Testing Harga Data Extraction")
    print("="*80)
    
    df_harga = extractor.extract_harga_data()
    if df_harga is not None:
        print(df_harga.head(10))
        print(f"\nTotal rows: {len(df_harga)}")
        print(f"Columns: {df_harga.columns.tolist()}")
        
        # Show data statistics
        print(f"\nData Statistics:")
        print(f"- Total objek wisata: {len(df_harga)}")
        print(f"- Objek wisata gratis: {df_harga[df_harga['gratis'] == 'Ya'].shape[0]}")
        print(f"- Objek wisata berbayar: {df_harga[df_harga['harga_tiket_dewasa'] > 0].shape[0]}")
        
        # Show price distribution
        print(f"\nPrice Distribution:")
        print(df_harga[['nama_objek_wisata', 'harga_tiket_dewasa', 'harga_tiket_anak', 'gratis']].to_string(index=False))
        
        # Show free attractions
        print(f"\n" + "="*80)
        print("Objek Wisata Gratis:")
        print("="*80)
        df_gratis = df_harga[df_harga['gratis'] == 'Ya'][['nama_objek_wisata', 'sumber_platform']]
        print(df_gratis.to_string(index=False))
        
        # Show paid attractions sorted by price
        print(f"\n" + "="*80)
        print("Objek Wisata Berbayar (Sorted by Price):")
        print("="*80)
        df_berbayar = df_harga[df_harga['harga_tiket_dewasa'] > 0].sort_values('harga_tiket_dewasa', ascending=False)
        df_berbayar_display = df_berbayar[['nama_objek_wisata', 'harga_tiket_dewasa', 'harga_tiket_anak']]
        print(df_berbayar_display.to_string(index=False))
        
    else:
        print("Harga data not available")
