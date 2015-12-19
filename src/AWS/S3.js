"use strict";

// module AWS.S3

var AWS = require('aws-sdk');

var s3 = new AWS.S3();

exports.getObjectAff = function(doneCallback) {
  return function(errCallback) {
    return function(bucket) {
      return function(key) {
        return function() {
          s3.getObject({Bucket: bucket, Key: key}, function(err, data) {
            if (err)
              errCallback(err)();
            else
              doneCallback(data)();
          });
        };
      };
    };
  };
};

exports.putObjectAff = function(doneCallback) {
  return function(errCallback) {
    return function(bucket) {
      return function(key) {
        return function(body) {
          return function() {
            s3.putObject({Bucket: bucket, Key: key, Body: body}, function(err, data) {
              if (err)
                errCallback(err);
              else
                doneCallback(data);
            });
          };
        };
      };
    };
  };
};