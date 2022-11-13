//
//  NoteItem.swift
//  iosApp
//
//  Created by amany on 31/10/2022.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI
import shared

struct NoteItem: View {
    
    var note : Note
    var onDeleteClick :() -> Void
    
    var body: some View {
        VStack (alignment:.leading){
            HStack{
                Text(note.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: onDeleteClick){
                    Image(systemName: "xmark").foregroundColor(.black)
                }
            }.padding(.bottom,3)
            
            Text(note.content)
                .fontWeight(.light)
                .padding(.bottom,3)
            
            HStack{
                Spacer()
                Text(DateUtils().formatNoteDate(dateTime:
                                                    note.created))
                    .font(.footnote)
                    .fontWeight(.light)
            }
            
        }.padding()
            .background(Color(hex: note.colorHex))
            .clipShape(RoundedRectangle(cornerRadius: 5.0))
    }
}

struct NoteItem_Previews: PreviewProvider {
    static var previews: some View {
        NoteItem(note: Note(id: nil, title: "first", content: "content", colorHex: 0xFF1234, created: DateUtils().now()), onDeleteClick: {})
    }
}
