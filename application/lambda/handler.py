from __future__ import print_function
import boto3
import base64
import json
import os
import logging

from botocore.exceptions import ClientError, ParamValidationError
from aws_xray_sdk.core import xray_recorder
from aws_xray_sdk.core import patch_all
from datetime import datetime


#variables
logger = logging.getLogger()
logger.setLevel(logging.INFO)

patch_all()

def _get_variable(name):
    try:
        name = os.environ[name]
        return name
    except KeyError as ke:
        logger.error('KeyError {}'.format(ke))
        raise ClientException("We didn't find the environment variable: {}.".format(name))

    return os.environ[name]


# Error message handling
def _error(message, code):
    if not isinstance(message, str):
        message = json.loads(message)

    response =  {
        "statusCode": code,
        "body": { "Message": message },
        "headers": {
            "Content-Type": "application/json",
        }
    }
    return response

# Success message handling
def _success(message, code):
    if not isinstance(message, str):
        message = json.loads(message)

    response =  {
        "statusCode": code,
        "body": { "Message": message },
        "headers": {
            "Content-Type": "application/json",
        }
    }
    return response

# clean empty attributes
def _clean_attributes(data):
   data_clean = dict((k, v) for k, v in data.items() if v)
   return data_clean

class ValueError(Exception):
    pass

class ClientException(Exception):
    pass