package com.example.noteappkmm.data.note

import com.example.noteappkmm.database.NoteDatabase
import com.example.noteappkmm.domain.note.Note
import com.example.noteappkmm.domain.note.NoteDataSource
import com.example.noteappkmm.domain.time.DateUtils

class SqlDelightNoteDataSource (db:NoteDatabase): NoteDataSource {

    val queries = db.notesQueries

    override suspend fun insertNote(note: Note) {
       queries.insertNote(
          id = note.id,
           title = note.title,
          content = note.content,
           colorHex = note.colorHex,
         created = DateUtils.toEpocMillies(note.created)
       )
    }

    override suspend fun getNoteById(id: Long): Note? {
        return queries.getNoteById(id)
            .executeAsOneOrNull()
            ?.toNote()
    }

    override suspend fun getAllNotes(): List<Note> {
       return queries.getAllNotes().executeAsList().map { it.toNote() }
    }

    override suspend fun deleteNoteById(id: Long) {
        return queries.deleteNoteById(id)
    }
}