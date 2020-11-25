//
//  QueueTasks.swift
//  RxSwiftExt
//
//  Created by Vijayendra Tripathi on 25/11/20.
//  Copyright © 2020 RxSwiftCommunity. All rights reserved.
//

import Foundation

/*
Author: Vijayendra Tripathi.
There may be cases where you might want to restrict number of tasks executed simultaneously.
For example, you may have a machine learning model that apply filters to an image and user may select
many images to apply filter for an image picker. In such cases, this operator can queue operations and execute only specific number of operations at a time.
*/

func queueTask<R>(maxTasks: Int, task: @escaping (Element) -> R) -> Observable<R> {
    let opQueue = OperationQueue()
    opQueue.maxConcurrentOperationCount = maxTasks
    return flatMap { element -> Observable<R> in
        return Observable.create { observer in
            opQueue.addOperation {
                let result = task(element)
                observer.onNext(result)
            }
            return Disposables.create()
        }
    }
}

/*
 Example Usage:
 .queueTask(maxTasks: 2) {
   // only 2 tasks will execute simultenously here.
   // Do something ..
 }
 .subscribe {
    // Observe results here
 }
 */
