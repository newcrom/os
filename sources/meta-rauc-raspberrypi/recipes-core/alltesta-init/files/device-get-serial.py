import urllib.request
import urllib.parse
import json
import os
import base64
import subprocess
import logging
from typing import Optional

# How to run?
# - curl -s  https://get.chrom.app/device-get-serial.py | python3 -

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)


def get_cpuid() -> str:
    logging.info("Retrieving CPU ID")
    try:
        with open("/proc/cpuinfo", "r", encoding="utf-8") as file:
            for line in file:
                if "Serial" in line:
                    parts = line.partition(":")
                    cpu_id = parts[2].strip()
                    logging.info(f"CPU ID: {cpu_id}")
                    return cpu_id
    except Exception as e:
        logging.error(f"Error retrieving CPU ID: {e}")
        raise


def get_mac_address() -> Optional[str]:
    paths = ["/sys/class/net/enu1u1/address", "/sys/class/net/eth0/address"]
    logging.info("Retrieving MAC Address")

    for path in paths:
        try:
            with open(path, "r", encoding="utf-8") as file:
                mac_address = file.read().strip()
                logging.info(f"MAC Address from {path}: {mac_address}")
                return mac_address
        except FileNotFoundError:
            logging.warning(f"MAC Address file not found at {path}")
        except IOError as e:
            logging.warning(f"IOError when accessing MAC Address at {path}: {e}")

    logging.error("Failed to retrieve MAC Address from all specified paths")
    return None


def get_ssh_folder_path() -> str:
    logging.info("Getting SSH folder path")
    ssh_folder = os.getenv("SSH_KEYS_FOLDER_PATH", "/data/root/.ssh")
    os.makedirs(ssh_folder, exist_ok=True)
    return ssh_folder


def get_serial_file_path() -> str:
    logging.info("Getting serial file path")
    return os.getenv("SERIAL_FILE_PATH", "/data/root/serial.txt")

def get_public_key() -> str:
    logging.info("Getting public key")
    file_path = os.path.join(get_ssh_folder_path(), "public.der")
    try:
        with open(file_path, "rb") as file:
            data = file.read()
            return base64.b64encode(data).decode("utf-8")
    except FileNotFoundError as e:
        logging.error(f"Public key file not found: {e}")
        raise
    except Exception as e:
        logging.error(f"Error getting public key: {e}")
        raise


def _get_openssl_version() -> Optional[list[str, str]]:
    try:
        result = subprocess.run(
            ["openssl", "version"],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True,
        )
        return result.stdout.strip().lower().split()[:2]
    except subprocess.CalledProcessError as e:
        logging.error(f"Error getting OpenSSL version: {e}")
        raise

def generate_keys() -> None:
    logging.info("Generating SSL keys")
    folder_path = get_ssh_folder_path()

    openssl_name, openssl_version = _get_openssl_version()
    should_use_traditional = False
    if openssl_name == "openssl" and openssl_version.startswith("3"):
        should_use_traditional = True

    try:
        genrsa_command = [
            "openssl",
            "genrsa",
            "-out",
            os.path.join(folder_path, "private.pem"),
            "2048"
        ]
        if should_use_traditional:
            genrsa_command.insert(2, "-traditional")

        subprocess.run(
            genrsa_command,
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )

        rsa_command = [
            "openssl",
            "rsa",
            "-in",
            os.path.join(folder_path, "private.pem"),
            "-pubout",
            "-outform",
            "DER",
            "-out",
            os.path.join(folder_path, "public.der")
        ]
        if should_use_traditional:
            rsa_command.insert(2, "-traditional")

        subprocess.run(
            rsa_command,
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
    except subprocess.CalledProcessError as e:
        logging.error(f"SSL Key Generation Error: {e}")
        raise
    except Exception as e:
        logging.error(f"Error generating SSL keys: {e}")
        raise


def send_initialization_request() -> None:
    logging.info("Sending initialization request")
    url = "https://hplc.cloud/api/cra/action"
    data = {
        "action": "initialize-hardware",
        "payload": {
            "public_key": get_public_key(),
            "type": "hub",
            "model": "slc",
            "cpuid": get_cpuid(),
            "mac_address": get_mac_address(),
        },
    }
    json_data = json.dumps(data).encode("utf-8")
    req = urllib.request.Request(url, data=json_data, method="POST")
    req.add_header("Content-Type", "application/json")
    try:
        with urllib.request.urlopen(req) as response:
            response_body = response.read().decode("utf-8")
            logging.info(f"Success: {response_body}")
            response_body_dict = json.loads(response_body)
            serial = response_body_dict.get("serial")
            if serial is not None:
                with open(get_serial_file_path(), "w") as file:
                    file.write(serial)
                logging.info("Serial is saved to file")
            else:
                raise ValueError("Device Serial Number is None")
    except Exception as e:
        logging.error(f"Error in sending initialization request: {e}")
        raise


def main():
    try:
        generate_keys()
        send_initialization_request()
    except Exception as e:
        logging.error(f"Error in main function: {e}")


if __name__ == "__main__":
    main()