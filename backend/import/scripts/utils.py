import logging
import sys
from datetime import datetime

LOG_FORMAT = "%(asctime)s [%(levelname)s] %(message)s"

def setup_logger(name: str = "import") -> logging.Logger:
    logger = logging.getLogger(name)
    logger.setLevel(logging.INFO)

    # File handler
    fh = logging.FileHandler("import.log")
    fh.setLevel(logging.INFO)
    fh.setFormatter(logging.Formatter(LOG_FORMAT))

    # Console handler
    ch = logging.StreamHandler(sys.stdout)
    ch.setLevel(logging.INFO)
    ch.setFormatter(logging.Formatter(LOG_FORMAT))

    logger.handlers.clear()
    logger.addHandler(fh)
    logger.addHandler(ch)
    return logger
