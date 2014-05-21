library test_helpers;

import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';
import 'package:unittest/unittest.dart';

/**
 * Adds a template into the TemplateCache.
 */
void addToTemplateCache(String path) {
    inject((TemplateCache cache) {
        HttpRequest request = new HttpRequest()
            ..open('GET', "../web/$path", async: false)
            ..send();
        cache.put(path, new HttpResponse(200, request.responseText));
    });
}

/**
 * Runs the provided function next tick so that asynchronous callbacks have time to run.
 */
Future asyncExpectation(Function fn) => new Future.delayed(Duration.ZERO, expectAsync(fn));
