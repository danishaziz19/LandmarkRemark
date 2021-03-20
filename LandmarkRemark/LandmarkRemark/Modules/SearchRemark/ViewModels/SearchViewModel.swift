//
//  SearchViewModel.swift
//  LandmarkRemark
//
//  Created by Danish Aziz on 20/3/21.
//

import Foundation

class SearchViewModel: NSObject {
    
    var remarks: [Remark] = []
    var filterRemarks: [Remark] = []
    private let searchRemarkPresenter: SearchRemarkPresenter
    let remarkService: RemarkServiceProvider = RemarkService(firebaseAPI: FirebaseAPI())
    
    init(searchRemarkPresenter: SearchRemarkPresenter) {
        self.searchRemarkPresenter = searchRemarkPresenter
    }
    
    func loadData() {
        remarkService.getRemarks { [weak self] (remarks, error) in
            if error != nil {
                print(error ?? "")
                return
            }
            self?.remarks = remarks
            self?.filterRemarks = remarks
            self?.searchRemarkPresenter.reload()
        }
    }
    
    func getRemarksCount() -> Int {
        return filterRemarks.count
    }
    
    func getRemarks(index: Int) -> Remark {
        return filterRemarks[index]
    }
    
    func filter(text: String) {
        if !text.isEmpty {
            self.filterRemarks = self.remarks.filter( { $0.userName.lowercased().contains(text) || $0.body.lowercased().contains(text) })
        } else {
            self.filterRemarks = self.remarks
        }
        searchRemarkPresenter.reload()
    }
}
