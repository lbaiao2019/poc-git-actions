from __future__ import print_function
import boto3
import json
import logging

from handler import _success
from handler import _error
from handler import _clean_attributes

#resources

#variables
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    # clean empty attributes
    event = _clean_attributes(event)    
    logger.info('EVENT={}'.format(event))

    try:
        return _success("Successfully processed.", 200)
    except Exception as e:
        logger.error('Exception {}'.format(e))
        return _error ("Processed with error.", 500)

class ClientException(Exception):
    pass
