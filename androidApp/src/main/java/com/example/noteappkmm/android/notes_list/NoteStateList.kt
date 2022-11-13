package com.example.noteappkmm.android.notes_list

import com.example.noteappkmm.domain.note.Note

data class NoteStateList(
    val notes: List<Note> = emptyList(),
    val searchText: String = "",
    val isSearchActive: Boolean = false
)