# Save the Dino, a CLI guessing game

Save the Dino is a guessing game based on the game hangman.  Instead of saving a man from hanging in the gallows, which is a pretty morbid premise, the player is tasked with saving the dino from an approaching asteroid by guessing the letters in the puzzle word correctly.  There are 5 levels of difficulty that the player can select.  When an incorrect letter is guessed, the asteroid approaches closer to the dino, and after 6 incorrect guesses, the asteroid strikes the dino and the game is over.  The player can request a hint, which uses an API to provide either a synonym from the Merriam-Webster Thesaurus, a definition from the Merriam-Webster Collegiate Dictionary, or a short description from Wikipedia.

## Project Requirements

1. Sqlite3 database accessed using ActiveRecord.
2. The three models in the app are User, Word, and GameSession. A User has many GameSessions and a Word has many GameSessions.
3. The word library was built from http://number27.org/assets/misc/words.txt, which provides a list of words ranked by frequency of use.  These words were saved into the database and the difficulty level for each word was determined by the word length divided by the frequency of use.
4. The User model can access their own record, view their win percentage, update their username, or delete their record.
5. The CLI displays prompts and updates accordingly.

## Install Instructions

1. Fork and clone this repository.
2. If, for some reason, the database does not download properly or gets corrupted, create a new database.
3. Rake the database migrations in terminal by running:

```bash 
rake db:migrate
```
4. Then, populate the word library by running the following ruby command in terminal
```terminal
ruby bin/initialize_lib.rb
``` 
5. Once the word library is populated, start the game by running
```terminal
ruby bin/run.rb
```

## Game Play
1. The Command Line Interface will prompt the user for a username.  If a new username is inputted, the program will create the new user and display a short How-To.  If an existing username is inputted, the program will add on to the username's history.
2. The Menu displays 5 options to Start New Game, View the Leaderboard, View your Records, Change your Username, or Delete Username and Exit.
3. If Start New Game is selected, the user is then prompted to select a difficulty level (1-5) which will select a word based on the difficulty calculated by the word length and the word's frequency.
4. The user can then guess letters in the puzzle word until they solve the puzzle or until they run out of tries and the solution is displayed.
5. A hint is available to the user by typing HINT.  Taking the hint will use one try.  The hint will either be a synonym or definition from the Merriam-Webster Thesaurus, or a short description from Wikipedia.
5. Inputting EXIT will allow the user to exit the game.

## Contributors
1. http://number27.org/assets/misc/words.txt
2. Spencer Lindemuth for all of his advice and support (https://github.com/SpencerLindemuth)
3. Stackoverflow and Quora

## License
Licensed under MIT License (https://github.com/PhilipSterling/module-one-final-project-guidelines-seattle-web-060319/blob/master/LICENSE.md)