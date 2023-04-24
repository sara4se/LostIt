//
//  AllReports.swift
//  Dalti
//
//  Created by Sara Alhumidi on 03/10/1444 AH.
//

import SwiftUI
import Firebase


struct Report {
    var title: String
    var content: String
}

struct AllReports: View {
 
        @State var reports: [Report] = []

        var body: some View {
            NavigationView {
                List(reports, id: \.title) { report in
                    NavigationLink(destination: Text(report.content)) {
                        Text(report.title)
                    }
                }
                .navigationTitle("All Reports")
            }
            .onAppear {
                fetchReports()
            }
        }

        func fetchReports() {
            let db = Firestore.firestore()
            db.collection("Community").document("Posts").collection("report").getDocuments { snapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }

                if let documents = snapshot?.documents {
                    self.reports = documents.map { document in
                        let data = document.data()
                        let title = data["title"] as? String ?? ""
                        let content = data["content"] as? String ?? ""
                        return Report(title: title, content: content)
                    }
                }
            }
        }
    }

struct AllReports_Previews: PreviewProvider {
    static var previews: some View {
        AllReports()
    }
}
