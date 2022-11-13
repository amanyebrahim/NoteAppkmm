//
//  NoteListScreen.swift
//  iosApp
//
//  Created by amany on 30/10/2022.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI
import shared

struct NoteListScreen: View {
    private var noteDataSource: NoteDataSource
    @StateObject var viewModel = NoteListViewModel(noteDataSource: nil)
    
    @State private var isNoteselected = false
    @State private var noteSelectedId: Int64? = nil
    
    
    init(noteDataSource: NoteDataSource){
        self.noteDataSource = noteDataSource
    }
    
    var body: some View {
        VStack {
        ZStack {
            NavigationLink(destination: NoteDetailsScreen(noteDataSource: self.noteDataSource,noteId: noteSelectedId), isActive: $isNoteselected){
                EmptyView()
            }.hidden()
            
            HiddeableSearchTextBar<NoteDetailsScreen>(onSearchToggled:{
                viewModel.toggleIsSearchActive()
            }, destinationProvider: {
                NoteDetailsScreen(
                    noteDataSource : self.noteDataSource,
                    noteId : nil
                )
            }, isSearchActive: viewModel.isSearchActive, searchText: $viewModel.searchText)
            
            if !viewModel.isSearchActive {
            Text("All Notes")
                .font(.title2)
            }
            
        }
            List{
                ForEach(viewModel.filteredNotes,id: \.self.id){ note in
                    Button(action: {
                        isNoteselected = true
                        noteSelectedId = note.id?.int64Value
                    }){
                        NoteItem(note: note, onDeleteClick:{
                            viewModel.deleteNoteById(id: note.id?.int64Value)
                        })
                    }
                }
            
            }.onAppear{
                viewModel.loadNotes()
                        }.listStyle(.plain)
                            .listRowSeparator(.hidden)
            
        }.onAppear{
            viewModel.setNoteDataSource(noteDataSource: noteDataSource)
        }
}

struct NoteListScreen_Previews: PreviewProvider {
    static var previews: some View {
       EmptyView()
    }
}
}
