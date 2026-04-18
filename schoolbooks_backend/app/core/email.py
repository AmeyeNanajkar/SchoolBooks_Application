import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from app.core.config import settings


def send_email(to_email: str, subject: str, body: str, is_html: bool = False) -> bool:
    if not settings.SMTP_HOST or not settings.SMTP_USER:
        print(f"[EMAIL] To: {to_email}")
        print(f"[EMAIL] Subject: {subject}")
        print(f"[EMAIL] Body: {body}")
        return True

    try:
        msg = MIMEMultipart("alternative")
        msg["From"] = f"{settings.SMTP_FROM_NAME} <{settings.SMTP_FROM_EMAIL}>"
        msg["To"] = to_email
        msg["Subject"] = subject

        if is_html:
            msg.attach(MIMEText(body, "html"))
        else:
            msg.attach(MIMEText(body, "plain"))

        with smtplib.SMTP(settings.SMTP_HOST, settings.SMTP_PORT) as server:
            server.starttls()
            server.login(settings.SMTP_USER, settings.SMTP_PASSWORD)
            server.sendmail(settings.SMTP_FROM_EMAIL, to_email, msg.as_string())

        return True
    except Exception as e:
        print(f"[EMAIL ERROR] {e}")
        return False


def send_otp_email(to_email: str, name: str, otp: str) -> bool:
    subject = "Reset Your SchoolBooks Password"
    body = f"""
Hi {name},

We received a request to reset your password.

Your OTP for password reset is: {otp}

This OTP will expire in {settings.OTP_EXPIRE_MINUTES} minutes.

If you didn't request this, please ignore this email.

Best regards,
SchoolBooks Team
"""
    return send_email(to_email, subject, body)


def send_welcome_email(to_email: str, name: str) -> bool:
    subject = "Welcome to SchoolBooks!"
    body = f"""
Hi {name},

Welcome to SchoolBooks!

Your account has been created successfully. You can now:
- Browse and search for school books
- Add books to your cart
- Place orders
- Track your deliveries

Get started by exploring our collection!

Best regards,
SchoolBooks Team
"""
    return send_email(to_email, subject, body)