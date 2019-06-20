# Save the Dino, a CLI guessing game

Save the Dino is a guessing game based on the game hangman.  Instead of saving a man from hanging in the gallows, which is a pretty morbid premise, the player is tasked with saving the dino from an approaching asteroid by guessing the letters in the puzzle word correctly.  There are 5 levels of difficulty that the player can select.  When an incorrect letter is guessed, the asteroid approaches closer to the dino, and after 6 incorrect guesses, the asteroid strikes the dino and the game is over.  The player can request a hint, which uses an API to provide either a synonym from the Merriam-Webster Thesaurus, a definition from the Merriam-Webster Collegiate Dictionary, or a short description from Wikipedia.

## Project Requirements

1. Sqlite3 database accessed using ActiveRecord.
2. The three models in the app are User, Word, and GameSession. A User has many GameSessions and a Word has many GameSessions.
3. The word library was built from http://number27.org/assets/misc/words.txt, which provides a list of words ranked by frequency of use.  These words were saved into the database and the difficulty level for each word was determined by the word length divided by the frequency of use.
4. The User model can access their own record, view their win percentage, update their username, or delete their record.
5. The CLI displays prompts and updates accordingly.

## Instructions

1. Fork and clone this repository.
2. Run the bin/run.rb and follow the prompts.
3. If the database does not download properly, rake the db migrations and call the Word.initialize_library located in bin/run.rb to populate the database with words.

## Contributors Guide
1. http://number27.org/assets/misc/words.txt
2. Spencer Lindemuth for all of his advice and support (https://github.com/SpencerLindemuth)

---
3. Make sure to create a good README.md with a short description, install instructions, a contributors guide and a link to the license for your code.
4. Make sure your project checks off each of the above requirements.
5. Prepare a video demo (narration helps!) describing how a user would interact with your working project.
    * The video should:
      - Have an overview of your project.(2 minutes max)
6. Prepare a presentation to follow your video.(3 minutes max)
    * Your presentation should:
      - Describe something you struggled to build, and show us how you ultimately implemented it in your code.
      - Discuss 3 things you learned in the process of working on this project.
      - Address, if anything, what you would change or add to what you have today?
      - Present any code you would like to highlight.   
7. *OPTIONAL, BUT RECOMMENDED*: Write a blog post about the project and process.

