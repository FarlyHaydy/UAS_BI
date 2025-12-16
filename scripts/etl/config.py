"""
Konfigurasi database dan environment
Support dual connection: admin (ETL) dan readonly (Dashboard)
"""
import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
import logging

# Load environment variables
load_dotenv()

class Config:
    """Database configuration"""
    
    DB_TYPE = os.getenv('DB_TYPE', 'postgresql')
    DB_HOST = os.getenv('DB_HOST', 'localhost')
    DB_PORT = os.getenv('DB_PORT', '5432')
    DB_NAME = os.getenv('DB_NAME', 'dw_pariwisata_jakarta')
    DB_USER = os.getenv('DB_USER', 'postgres')
    DB_PASSWORD = os.getenv('DB_PASSWORD', '')
    
    # Readonly credentials
    DB_READONLY_USER = os.getenv('DB_READONLY_USER', 'dw_readonly')
    DB_READONLY_PASSWORD = os.getenv('DB_READONLY_PASSWORD', '')
    
    @classmethod
    def get_connection_string(cls, readonly=False):
        """
        Generate SQLAlchemy connection string
        
        Args:
            readonly (bool): If True, use readonly credentials
        """
        if readonly:
            user = cls.DB_READONLY_USER
            password = cls.DB_READONLY_PASSWORD
        else:
            user = cls.DB_USER
            password = cls.DB_PASSWORD
            
        return f"{cls.DB_TYPE}://{user}:{password}@{cls.DB_HOST}:{cls.DB_PORT}/{cls.DB_NAME}"
    
    @classmethod
    def get_engine(cls, readonly=False):
        """
        Create SQLAlchemy engine
        
        Args:
            readonly (bool): If True, create readonly engine for dashboard
        """
        connection_string = cls.get_connection_string(readonly=readonly)
        return create_engine(connection_string)
    
    @classmethod
    def get_admin_engine(cls):
        """Get admin engine (for ETL)"""
        return cls.get_engine(readonly=False)
    
    @classmethod
    def get_readonly_engine(cls):
        """Get readonly engine (for Dashboard)"""
        return cls.get_engine(readonly=True)

# Data paths - DISESUAIKAN DENGAN LOKASI FILE YANG BENAR
# File kunjungan ada di portal_satu_data
KUNJUNGAN_DATA_PATH = os.path.join('data', 'raw', 'portal_satu_data')
EXCEL_FILE = 'jumlah-kunjungan-wisatawan-ke-obyek-wisata-menurut-lokasi-di-provinsi-dki-jakarta.xlsx'

# File harga ada di manual_collection
HARGA_DATA_PATH = os.path.join('data', 'raw', 'manual_collection')
HARGA_FILE = 'harga_tiket_wisata_jakarta.xlsx'

# Untuk backward compatibility (jika ada code lama yang pakai DATA_PATH)
DATA_PATH = KUNJUNGAN_DATA_PATH

# Logging configuration
os.makedirs('logs', exist_ok=True)  # Buat folder logs jika belum ada

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('logs/etl.log'),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)
