#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 
do
# get winner name
  if [[ $WINNER != 'winner' ]]
  then
    #get team_id
    TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")

    #if not found
    if [[ -z $TEAM_NAME ]]
      then 
      #insert team
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo "Inserted into teams", $WINNER
      fi
    fi
  fi

#get opponent name
  if [[ $OPPONENT != 'opponent' ]]
  then
    #get team_id
    TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")

    #if not found
    if [[ -z $TEAM_NAME ]]
      then 
      #insert team
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo "Inserted into teams", $OPPONENT
      fi
    fi
  fi

#inserting all the data into game, each info gets its own column
  if [[ $YEAR != 'year' && $ROUND != 'round' && $WINNER != 'winner' && $OPPONENT != 'opponent' && $WINNER_GOALS != 'winner_goals' && $OPPONENT_GOALS != 'opponent_goals' ]]
  then
    #get teams_ids
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    
    #insert values into databank
    INSERT_INFO=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES('$YEAR','$ROUND','$WINNER_ID','$OPPONENT_ID','$WINNER_GOALS','$OPPONENT_GOALS')")

  fi

done
