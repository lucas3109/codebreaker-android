// DB Score Creation file

/// DATABASE PART.......................................
import flash.filesystem.File;
var dbFile:File = File.applicationDirectory.resolvePath("LiveScoresDB.db");

var dbTemplate:File = new File();
private var conn:SQLConnection = new SQLConnection();
private var createStmt:SQLStatement = new SQLStatement();
private var selectStmt:SQLStatement = new SQLStatement();
private var insertStmt:SQLStatement = new SQLStatement();
private var deleteStmt:SQLStatement = new SQLStatement();
public var resultObj:Object;

public function initDB()
{
	if (!dbFile.exists)
	{
		dbTemplate = File.applicationDirectory.resolvePath("DBTemplate.db");
		dbTemplate.copyTo(dbFile);
	}
}

public function realInit()
{
	try
	{
		conn.open(dbFile);
		tables();
		
	}
	catch (error:SQLError)
	{
		trace("Error message:", error.message);
		trace("Details:", error.details);
	}
}



public function tables():void
{
	
	createStmt.sqlConnection = conn;
	var sql:String = 
		"CREATE TABLE IF NOT EXISTS ScoresView1 (" + 
		"    empid INTEGER NOT NULL, " + 
		"    date TEXT, " + 
		"    month TEXT, " + 
		"    year TEXT," +
		"    loss TEXT," +
		"	 total TEXT,"	 +
		"	 score TEXT," +
		"	 success TEXT"+
		")";
	//alter table name addColumn "complete TEXT"
	
	createStmt.text = sql;
	createStmt.execute();
	createStmt.addEventListener(SQLEvent.RESULT, createResult);
	createStmt.addEventListener(SQLErrorEvent.ERROR, createError);
}


public function createError(event:SQLErrorEvent):void
{
	
	//Alert.show("An error occured....");
}

public function createResult(event:SQLEvent):void
{}

var datesArr = new Array();
public var wins_ = 0;
public var total_ = 0;
public var loss_ = 0;
public var LastGameLost = false;
public var dataDG;

public function nowShow()
{
	selectStmt.sqlConnection = conn;
	
	selectStmt.text = "SELECT * FROM ScoresView1";
	//selectStmt.parameters[":param1"] = getMonthStr(mainCalendar.displayedMonth);
	//selectStmt.parameters[":param1"] = new Date().fullYear;
	
	
	// This try..catch block is fleshed out in
	// a subsequent code listing
	try
	{
		selectStmt.execute();
		// accessing the data is shown in a subsequent code listing
		var result:SQLResult = selectStmt.getResult();
		if(result.data==null)
		{
			initScores();
			selectStmt.execute();
			result = selectStmt.getResult();
		}
		wins_ = result.data[0].score;
		total_ = result.data[0].total;
		loss_ = result.data[0].loss;
		var score_ = result.data[0].score;
		//dataDG = result.data[0];
		resultObj = {total:total_,loss:loss_,score:score_};
		
		var obj:Object;
		
	}
	catch (error:SQLError)
	{
		//Alert.show("no data for this month!");
	}
}

//Saving the score ...
public function saveScores()
{
	deleteNow();
	insertStmt.sqlConnection = conn;
	var today_date:Date = new Date();
	var sql:String = 
		"INSERT INTO ScoresView1 (empId,date, month, year,loss,total,score,success) " + 
		"VALUES (:empId, :date, :month, :year,:loss,:total, :score, :success)";
	insertStmt.text = sql;
	//insertStmt.parameters[":ID"] = add()
	var y = new Date().fullYear;
	var date:Date = new Date();
	var finalLost = getLoss();
	var finalTotal = Number(this.total_)+1;
	var finalWins = getWins();
	insertStmt.parameters[":empId"] = 1000;
	insertStmt.parameters[":month"] = date.getMonth();
	insertStmt.parameters[":date"] = date.date;
	insertStmt.parameters[":year"] = y;
	insertStmt.parameters[":loss"] =  finalLost
	insertStmt.parameters[":total"] = finalTotal;
	insertStmt.parameters[":score"] = finalWins;
	insertStmt.parameters[":success"] = getSuccess(finalWins,finalTotal,LastGameLost)+"%";
	
	try
	{
		// execute the statement
		insertStmt.execute();
		
		//Alert.show("All done!");
		nowShow();
		
		
	}
	catch (error:SQLError)
	{
		//Alert.show((error.details).toString());
	}
}

public function getLoss()
{
	var thisLoss;
	if(LastGameLost==true)
		thisLoss = Number(this.loss_)+1;
	else
		thisLoss = Number(loss_);
return thisLoss;
}

public function getWins()
{
	var thisWins;
	if(LastGameLost==true)
		thisWins = Number(wins_);
	else 
		thisWins = Number(this.wins_)+1;
	return thisWins;
}


//INIT SCORES 

public function initScores()
{
	deleteNow();
	insertStmt.sqlConnection = conn;
	var today_date:Date = new Date();
	var sql:String = 
		"INSERT INTO ScoresView1 (empId,date, month, year,loss,total,score,success) " + 
		"VALUES (:empId, :date, :month, :year,:loss,:total, :score, :success)";
	insertStmt.text = sql;
	//insertStmt.parameters[":ID"] = add()
	var y = new Date().fullYear;
	var date:Date = new Date();
	insertStmt.parameters[":empId"] = 1000;
	insertStmt.parameters[":month"] = date.getMonth();
	insertStmt.parameters[":date"] = date.date;
	insertStmt.parameters[":year"] = y;
	insertStmt.parameters[":loss"] = 0;
	insertStmt.parameters[":total"] = 0;
	insertStmt.parameters[":score"] = 0;
	insertStmt.parameters[":success"] = 0+"%";
	
	try
	{
		// execute the statement
		insertStmt.execute();
		//Alert.show("All done!");
		nowShow();
	}
	catch (error:SQLError)
	{
		//Alert.show((error.details).toString());
	}
}

public function getSuccess(wins,total,loss=false)
{
	total = loss==true?Number(total)+1:Number(total);
	var finalScore = (Number(wins)/Number(total))*100;
	Math.round(Number(finalScore));
	finalScore = String(finalScore).split(".");
	finalScore = String(finalScore).split(",");
	return finalScore[0];
}

////////////// DELETE FUNCTION ///////////////////////

public function deleteNow(flag=false):void
{
	deleteStmt.sqlConnection = conn;
	
		deleteStmt.text = "DELETE FROM ScoresView1 WHERE empid = :param1";
		deleteStmt.parameters[":param1"] = 1000
		
		// This try..catch block is fleshed out in
		// a subsequent code listing
		try
		{
			deleteStmt.execute();
		}
		catch (error:SQLError)
		{
			//Alert.show("no data!");
		}
	if(flag)
		nowShow();
}








//EOF i hate EOF chars...