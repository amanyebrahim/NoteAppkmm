//
//  NoteDetailsScreen.swift
//  iosApp
//
//  Created by amany on 31/10/2022.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI
import shared

struct NoteDetailsScreen: View {
    
     var noteDataSource: NoteDataSource
     var noteId: Int64? = nil
    
    @StateObject var viewModel = NoteDetailsViewModel(noteDataSource: nil)
    
    @Environment(\.presentationMode) var presentation
    
    init(noteDataSource:NoteDataSource,noteId:Int64?){
        self.noteDataSource = noteDataSource
        self.noteId = noteId
    }
    
    var body: some View {
        VStack(alignment: .leading){
            
            TextField("Enter Title.....",text: $viewModel.noteTitle)
                .font(.title)
            
            TextField("Enter Content.....",text: $viewModel.noteContent)
                
            Spacer()
            
        }.toolbar(content: {
            Button(action:{
                viewModel.saveNote {
                    self.presentation.wrappedValue.dismiss()
                }
                
            }){
                Image(systemName: "checkmark")
            }
        }).padding()
            .background(Color(hex: viewModel.noteColor))
            .onAppear{
                viewModel.setParamAndLoadNote(noteDataSource: noteDataSource, noteId: self.noteId)
            }
    }
}

struct NoteDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
      EmptyView()
    }
}
