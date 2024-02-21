//
//  ContentProvider.swift
//  TopShelf
//
//  Created by Eyüp Mert on 21.02.2024.
//

import TVServices

class ContentProvider: TVTopShelfContentProvider {

    override func loadTopShelfContent(completionHandler: @escaping (TVTopShelfContent?) -> Void) {
        // Fetch content and call completionHandler
        completionHandler(nil);
    }

}

