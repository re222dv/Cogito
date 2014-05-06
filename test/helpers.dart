library test_helpers;

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';

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
