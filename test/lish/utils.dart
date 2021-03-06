// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_test_handler/shelf_test_handler.dart';
import 'package:test/test.dart';

import 'package:pub/src/io.dart';

void handleUploadForm(ShelfTestServer server, [Map body]) {
  server.handler.expect('GET', '/api/packages/versions/new', (request) {
    expect(
        request.headers, containsPair('authorization', 'Bearer access token'));

    if (body == null) {
      body = {
        'url': server.url.resolve('/upload').toString(),
        'fields': {'field1': 'value1', 'field2': 'value2'}
      };
    }

    return new shelf.Response.ok(JSON.encode(body),
        headers: {'content-type': 'application/json'});
  });
}

void handleUpload(ShelfTestServer server) {
  server.handler.expect('POST', '/upload', (request) {
    // TODO(nweiz): Once a multipart/form-data parser in Dart exists, validate
    // that the request body is correctly formatted. See issue 6952.
    return drainStream(request.read())
        .then((_) => server.url)
        .then((url) => new shelf.Response.found(url.resolve('/create')));
  });
}
