from __future__ import print_function
import json
import logging
import os

from aws_xray_sdk.core import xray_recorder
from aws_xray_sdk.core import patch_all

patch_all()

from handler import _success
from handler import _error
from handler import _clean_attributes

#resources

#variables
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info('EVENT={}'.format(event))
    event = _clean_attributes(event)

    try:
        return _success("Successfully processed.", 200)
    except ClientException as ce:
        logger.error('ClientException {}'.format(ce))
        return _error ("Processed with error.", 500)
    except ValueError as ve:
        logger.error('ValueError {}'.format(ve))
        return _error ("Processed with error.", 500)
    except Exception as e:
        logger.error('Exception {}'.format(e))
        return _error ("Processed with error.", 500)


class ClientException(Exception):
    pass
