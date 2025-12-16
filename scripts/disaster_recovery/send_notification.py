"""
Email notification untuk disaster recovery events
Compatible with Docker environment
"""
import smtplib
import sys
import os
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from datetime import datetime
import argparse

# Add parent directory to path for imports
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'etl'))

try:
    from config import (
        EMAIL_ENABLED, SMTP_SERVER, SMTP_PORT, SMTP_USE_TLS,
        SMTP_USERNAME, SMTP_PASSWORD, SMTP_FROM_EMAIL, SMTP_FROM_NAME,
        ALERT_RECIPIENTS, logger
    )
except ImportError:
    # Fallback untuk environment tanpa config.py
    EMAIL_ENABLED = os.getenv('EMAIL_ENABLED', 'false').lower() == 'true'
    SMTP_SERVER = os.getenv('SMTP_SERVER', 'smtp.gmail.com')
    SMTP_PORT = int(os.getenv('SMTP_PORT', '587'))
    SMTP_USE_TLS = os.getenv('SMTP_USE_TLS', 'true').lower() == 'true'
    SMTP_USERNAME = os.getenv('SMTP_USERNAME', os.getenv('ALERT_EMAIL_FROM', ''))
    SMTP_PASSWORD = os.getenv('SMTP_PASSWORD', os.getenv('ALERT_EMAIL_PASSWORD', ''))
    SMTP_FROM_EMAIL = os.getenv('SMTP_FROM_EMAIL', SMTP_USERNAME)
    SMTP_FROM_NAME = os.getenv('SMTP_FROM_NAME', 'DW Pariwisata Jakarta')
    ALERT_RECIPIENTS = os.getenv('ALERT_RECIPIENTS', os.getenv('ALERT_EMAIL_TO', '')).split(',')
    
    # Simple logger fallback
    import logging
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)


def send_email(subject, body, notification_type='info'):
    """
    Send email notification
    
    Args:
        subject: Email subject
        body: Email body (plain text)
        notification_type: 'success', 'error', 'warning', 'info'
    
    Returns:
        bool: True if sent successfully, False otherwise
    """
    if not EMAIL_ENABLED:
        logger.warning("Email notifications are disabled (EMAIL_ENABLED=false)")
        print("⚠️  Email notifications disabled")
        return False
    
    # Clean up recipients list
    recipients = [r.strip() for r in ALERT_RECIPIENTS if r.strip()]
    
    if not recipients:
        logger.error("No email recipients configured (ALERT_RECIPIENTS is empty)")
        print("❌ No email recipients configured!")
        return False
    
    if not SMTP_USERNAME or not SMTP_PASSWORD:
        logger.error("SMTP credentials not configured")
        print("❌ SMTP credentials missing!")
        print(f"   SMTP_USERNAME: {'✓' if SMTP_USERNAME else '✗'}")
        print(f"   SMTP_PASSWORD: {'✓' if SMTP_PASSWORD else '✗'}")
        return False
    
    try:
        # Email content
        msg = MIMEMultipart()
        msg['From'] = f"{SMTP_FROM_NAME} <{SMTP_FROM_EMAIL}>"
        msg['To'] = ', '.join(recipients)
        msg['Subject'] = f"[{notification_type.upper()}] {subject}"
        
        # Add timestamp and hostname
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        hostname = os.getenv('HOSTNAME', 'Docker Container')
        
        full_body = f"""
========================================
DW PARIWISATA JAKARTA - NOTIFICATION
========================================

Timestamp: {timestamp}
Host: {hostname}
Type: {notification_type.upper()}

========================================
MESSAGE
========================================

{body}

========================================
SYSTEM INFO
========================================

Container: {os.getenv('HOSTNAME', 'Unknown')}
Environment: Docker
Database: {os.getenv('DB_NAME', 'dw_pariwisata_jakarta')}
DB Host: {os.getenv('DB_HOST', 'postgres')}

========================================

This is an automated message from DW Pariwisata Jakarta Disaster Recovery System.
Do not reply to this email.
"""
        
        msg.attach(MIMEText(full_body, 'plain'))
        
        # Send email
        logger.info(f"Sending email to {len(recipients)} recipient(s): {', '.join(recipients)}")
        print(f"📧 Sending email to: {', '.join(recipients)}")
        
        with smtplib.SMTP(SMTP_SERVER, SMTP_PORT, timeout=30) as server:
            server.set_debuglevel(0)  # Set to 1 for debug output
            
            if SMTP_USE_TLS:
                server.starttls()
            
            server.login(SMTP_USERNAME, SMTP_PASSWORD)
            server.send_message(msg)
        
        logger.info("✓ Email sent successfully")
        print("✅ Email sent successfully!")
        return True
        
    except smtplib.SMTPAuthenticationError as e:
        logger.error(f"SMTP Authentication failed: {e}")
        print(f"❌ Email authentication failed!")
        print("   Check your Gmail App Password")
        return False
        
    except smtplib.SMTPException as e:
        logger.error(f"SMTP error: {e}")
        print(f"❌ Email sending failed: {e}")
        return False
        
    except Exception as e:
        logger.error(f"Failed to send email: {e}")
        print(f"❌ Unexpected error: {e}")
        import traceback
        traceback.print_exc()
        return False


def main():
    """Main entry point for command-line usage"""
    parser = argparse.ArgumentParser(
        description='Send disaster recovery notification email'
    )
    parser.add_argument(
        '--type',
        required=True,
        choices=['success', 'error', 'warning', 'info'],
        help='Notification type'
    )
    parser.add_argument(
        '--subject',
        help='Email subject (auto-generated if not provided)'
    )
    parser.add_argument(
        '--message',
        required=True,
        help='Email message body'
    )
    
    args = parser.parse_args()
    
    # Auto-generate subject if not provided
    if not args.subject:
        subjects = {
            'success': 'ETL Process Completed Successfully',
            'error': 'ETL Process Failed - Action Required',
            'warning': 'ETL Process Warning',
            'info': 'ETL Process Information'
        }
        args.subject = subjects.get(args.type, 'ETL Notification')
    
    print()
    print("="*80)
    print("EMAIL NOTIFICATION SYSTEM")
    print("="*80)
    print(f"Type: {args.type}")
    print(f"Subject: {args.subject}")
    print(f"Message: {args.message[:50]}...")
    print("="*80)
    print()
    
    # Print configuration status
    print("Configuration:")
    print(f"  EMAIL_ENABLED: {EMAIL_ENABLED}")
    print(f"  SMTP_SERVER: {SMTP_SERVER}:{SMTP_PORT}")
    print(f"  SMTP_USERNAME: {SMTP_USERNAME if SMTP_USERNAME else '(not set)'}")
    print(f"  SMTP_PASSWORD: {'***' if SMTP_PASSWORD else '(not set)'}")
    print(f"  RECIPIENTS: {', '.join([r for r in ALERT_RECIPIENTS if r])}")
    print()
    
    # Send email
    success = send_email(args.subject, args.message, args.type)
    
    print()
    print("="*80)
    if success:
        print("✅ NOTIFICATION SENT SUCCESSFULLY")
    else:
        print("❌ NOTIFICATION FAILED")
    print("="*80)
    print()
    
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
