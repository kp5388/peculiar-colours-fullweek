import flixel.FlxG;

class Ratings
{
    public static function GenerateLetterRank(accuracy:Float) // generate a letter ranking
    {
        var ranking:String = "???";
		if(FlxG.save.data.botplay && !PlayState.loadRep)
			ranking = "BotPlay";

        if (PlayState.misses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods == 0) // Marvelous (SICK) Full Combo
            ranking = "(MFC)";
        else if (PlayState.misses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
            ranking = "(GFC)";
        else if (PlayState.misses == 0) // Regular FC
            ranking = "(FC)";
        else if (PlayState.misses < 10) // Single Digit Combo Breaks
            ranking = "(SDCB)";
        else
            ranking = "(Clear)";

        // WIFE TIME :)))) (based on Wife3) //nah fuck off this is my port i make the rules here bitch

        var wifeConditions:Array<Bool> = [
            accuracy >= 100, // SS
            accuracy >= 95, // S
            accuracy >= 90, // A (A:)
            accuracy >= 80, // B (A)
            accuracy >= 60, // C
            accuracy < 60 // D

            //accuracy >= 99.9935, // AAAAA
            //accuracy >= 99.980, // AAAA:
            //accuracy >= 99.970, // AAAA.
            //accuracy >= 99.955, // AAAA
            //accuracy >= 99.90, // AAA:
            //accuracy >= 99.80, // AAA.
            //accuracy >= 99.70, // AAA
            //accuracy >= 99, // AA:
            //accuracy >= 96.50, // AA.
            //accuracy >= 93, // AA
            //accuracy >= 85, // A.
            //accuracy >= 70, // B
        ];

        for(i in 0...wifeConditions.length)
        {
            var b = wifeConditions[i];
            if (b)
            {
                switch(i)
                {
                    case 0:
                        ranking += " SS";
                    case 1:
                        ranking += " S";
                    case 2:
                        ranking += " A";
                    case 3:
                        ranking += " B";
                    case 4:
                        ranking += " C";
                    case 5:
                        ranking += " D";

//                    case 1:
//                        ranking += " AAAAA";
//                    case 2:
//                        ranking += " AAAA:";
//                    case 3:
//                        ranking += " AAAA.";
//                    case 4:
//                        ranking += " AAAA";
//                    case 5:
//                        ranking += " AAA:";
//                    case 6:
//                        ranking += " AAA.";
//                    case 7:
//                        ranking += " AAA";
//                    case 8:
//                        ranking += " AA:";
//                    case 9:
//                        ranking += " AA.";
//                    case 10:
//                        ranking += " AA";
//                    case 11:
//                        ranking += " A:";
//                    case 12:
//                        ranking += " A.";
//                    case 13:
//                        ranking += " A";
//                    case 14:
//                        ranking += " B";
//                    case 15:
//                        ranking += " C";
//                    case 16:
//                        ranking += " D";

                }
                break;
            }
        }

        if (accuracy == 0)
            ranking = "???";
		else if(FlxG.save.data.botplay && !PlayState.loadRep)
			ranking = "BotPlay";

        return ranking;
    }
    
    public static function CalculateRating(noteDiff:Float, ?customSafeZone:Float):String // Generate a judgement through some timing shit
    {

        var customTimeScale = Conductor.timeScale;

        if (customSafeZone != null)
            customTimeScale = customSafeZone / 166;

        // trace(customTimeScale + ' vs ' + Conductor.timeScale);

        // I HATE THIS IF CONDITION
        // IF LEMON SEES THIS I'M SORRY :(

        // trace('Hit Info\nDifference: ' + noteDiff + '\nZone: ' + Conductor.safeZoneOffset * 1.5 + "\nTS: " + customTimeScale + "\nLate: " + 155 * customTimeScale);
	
        var rating = checkRating(noteDiff,customTimeScale);


        return rating;
    }

    public static function checkRating(ms:Float, ts:Float)
    {
        var rating = "shit";
        if (ms <= 166 * ts && ms >= 135 * ts)
            rating = "shit";
        if (ms < 135 * ts && ms >= 90 * ts) 
            rating = "bad";
        if (ms < 90 * ts && ms >= 45 * ts)
            rating = "good";
        if (ms < 45 * ts && ms >= -45 * ts)
            rating = "sick";
        if (ms > -90 * ts && ms <= -45 * ts)
            rating = "good";
        if (ms > -135 * ts && ms <= -90 * ts)
            rating = "bad";
        if (ms > -166 * ts && ms <= -135 * ts)
            rating = "shit";
        return rating;
    }

    public static function CalculateRanking(score:Int,scoreDef:Int,nps:Int,maxNPS:Int,accuracy:Float):String
    {
        return
         (FlxG.save.data.npsDisplay ?																							// NPS Toggle
         "NPS: " + nps + " (Max " + maxNPS + ")" + (!PlayStateChangeables.botPlay || PlayState.loadRep ? " | " : "") : "") +								// 	NPS
         (!PlayStateChangeables.botPlay || PlayState.loadRep ? "Score:" + (Conductor.safeFrames != 10 ? score + " (" + scoreDef + ")" : "" + score) + 		// Score
         (FlxG.save.data.accuracyDisplay ?																						// Accuracy Toggle
         " | Misses:" + PlayState.misses + 																				// 	Misses/Combo Breaks
         " | Accuracy:" + (PlayStateChangeables.botPlay && !PlayState.loadRep ? "???" : HelperFunctions.truncateFloat(accuracy, 2) + "%") +  				// 	Accuracy
         " - " + GenerateLetterRank(accuracy) : "") : ""); 																		// 	Letter Rank
    }
}
