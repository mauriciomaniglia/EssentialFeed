//
//  MainQueueDispatchDecorator.swift
//  EssentialFeediOS
//
//  Created by Mauricio Maniglia on 26/01/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation
import EssentialFeed

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T

    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }

        completion()
     }
}

extension MainQueueDispatchDecorator: FeedLoader where T == FeedLoader {
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: FeedImageDataLoader where T == FeedImageDataLoader {
   func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
       return decoratee.loadImageData(from: url) { [weak self] result in
           self?.dispatch { completion(result) }
       }
   }
}
