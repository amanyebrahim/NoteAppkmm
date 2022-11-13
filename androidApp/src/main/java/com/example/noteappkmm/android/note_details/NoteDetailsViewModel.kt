package com.example.noteappkmm.android.note_details

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.noteappkmm.domain.note.Note
import com.example.noteappkmm.domain.note.NoteDataSource
import com.example.noteappkmm.domain.time.DateUtils
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import javax.inject.Inject


@HiltViewModel
class NoteDetailsViewModel @Inject constructor(
    private val noteDataSource: NoteDataSource,
    private val savedStateHandle: SavedStateHandle
) : ViewModel() {

    private val noteTitle = savedStateHandle.getStateFlow("noteTitle", "")
    private val noteContent = savedStateHandle.getStateFlow("noteContent", "")
    private val isNoteTitleFocused = savedStateHandle.getStateFlow("isNoteTitleFocused", false)
    private val isNoteContentFocused = savedStateHandle.getStateFlow("isNoteContentFocused", false)
    private val noteColor = savedStateHandle.getStateFlow("noteColor", Note.generateRandomColor())
    private val _hasNotBeenSaved = MutableStateFlow(false)
    val hasNoteBeenSaved = _hasNotBeenSaved.asStateFlow()
    private var existingNoteId: Long? = null
    val state = combine(
        noteTitle,
        noteContent,
        isNoteTitleFocused,
        isNoteContentFocused,
        noteColor
    ) { title, content, isTitleFocused, isContentFocused, color ->
        NoteDetailsState(
            noteTitle = title,
            noteContent = content,
            isNoteTitleHintVisible = title.isEmpty() && !isTitleFocused,
            isNoteContentHintVisible = content.isEmpty() &&!isContentFocused,
            noteColor = color
        )
    }.stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), NoteDetailsState())

    init {
        savedStateHandle.get<Long>("noteId")?.let { existingId ->
            if (existingId == -1L)
                return@let
            existingNoteId = existingId

            viewModelScope.launch {
                noteDataSource.getNoteById(existingId)?.let { note ->
                    savedStateHandle["noteTitle"] = note.title
                    savedStateHandle["noteContent"] = note.content
                    savedStateHandle["noteColor"] = note.colorHex
                }
            }
        }
    }


    fun onNoteTitleChange(text: String) {
        savedStateHandle["noteTitle"] = text
    }

    fun onNoteContentChange(text: String) {
        savedStateHandle["noteContent"] = text
    }

    fun onNoteTitleFocusedChange(isFocused: Boolean) {
        savedStateHandle["isNoteTitleFocused"] = isFocused
    }

    fun onNoteContentFocusedChange(isFocused: Boolean) {
        savedStateHandle["isNoteContentFocused"] = isFocused
    }

    fun saveNote() {
        viewModelScope.launch {
            noteDataSource.insertNote(
                Note(
                id = existingNoteId,
                    title = noteTitle.value,
                    content = noteContent.value,
                    colorHex = noteColor.value,
                    created = DateUtils.now()
                )
            )
            _hasNotBeenSaved.value = true
        }
    }
}