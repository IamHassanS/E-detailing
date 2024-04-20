//
//  PlayPDFCVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 29/01/24.
//

import UIKit
import PDFKit
class PlayPDFCVC: UICollectionViewCell {
    let pdfView: PDFView = {
        let view = PDFView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(pdfView)
       // pdfView.frame = contentView.bounds
        
        NSLayoutConstraint.activate([
              pdfView.topAnchor.constraint(equalTo: contentView.topAnchor),
              pdfView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
              pdfView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
              pdfView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
          ])
        
    }
    
    func toLoadData(data: Data) {
            // your PDF data, fetched or loaded from somewhere
        
             let document = PDFDocument(data: data)

            pdfView.document = document
           
     
            
    }

}
