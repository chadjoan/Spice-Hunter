// This is the Actionscript 3 builder by Chad Joan

import std.algorithm;
import std.range;
import std.stdio;
import std.file;
import std.path;
import std.conv;
import std.string;
import std.array;
import std.stdio;
import std.process;
import std.regex;
import std.datetime;
import std.parallelism;

const char[] defaultArgs = " -default-size 800 600";

string[] assetExts;
//immutable char[][] assetExts =
//[
//"swf", // this is gone
//
//// some sorta vector graphic format
//"svg",
//
//// image types
//"jpg",
//"jpeg",
//"png",
//"gif",
//
//// sound files
//"mp3",
//
//// font file(s)
//"ttf",
//];

immutable string[] swfExts = ["swf (disabled!)"];
immutable string[] imageExts = ["jpg","jpeg","png","gif"]; //["svg"];
immutable string[] soundExts = ["mp3"];
immutable string[] fontExts = ["ttf"];

static Regex!char fileRegExp;

static this()
{
    //swfExts = assetExts[0..1].dup;
    //imageExts = assetExts[2..6];
    //soundExts = assetExts[6..7];
    //fontExts = assetExts[7..8];
	assetExts = new string[0];
	assetExts ~= swfExts;
	assetExts ~= imageExts;
	assetExts ~= soundExts;
	assetExts ~= fontExts;
    
    fileRegExp = regex( "Assets[.][_A-Za-z].*?[^_A-Za-z0-9]", "g" );
}

enum // extension type
{
    SWF,
    IMAGE,
    SOUND,
    FONT
}

uint extType( string extension )
{
    if ( extension[0] is '.' )
        extension = extension[1..$];
    
    if ( swfExts.contains( extension ) )
        return SWF;
    
    if ( imageExts.contains( extension ) )
        return IMAGE;
    
    if ( soundExts.contains( extension ) )
        return SOUND;
    
    if ( fontExts.contains( extension ) )
        return FONT;
	
	assert(0);
}

int main( string[] args )
{
    // if this ever needs optimizing, 
    // linked lists would probably be much faster for some of this stuff
    auto srcFiles = new string[0];
    auto rootdirs = new string[1]; // one for the cwd
    auto assetFiles = new string[0];
    auto passedArgs = new string[0];
    shared assetsReferenced = cast(shared)(new string[0]);
	string[] assetsUsed;
    auto cwd = std.file.getcwd();
    auto mainDir = cwd;
    string resultName = null;
    bool showUnused = false; // show which files aren't embedded by a3
    bool explicitResultName = false;
    /+uint xRes = 800;
    uint yRes = 600;
    uint fps = 30;
    uint flashVersion = 8;+/
    bool recursive = true;
    bool compile = true;
    
    if ( args.length <= 1 )
    {
        printUsage();
        goto done;
    }
    
    rootdirs[0] = cwd;
    
    //---------------------------------------------------------------------
    // Parse the command line arguments. 
    //---------------------------------------------------------------------
    
    bool outputtemp = false;
    bool skip = true; // used to signal that we used up the argument 
                       //   following the current argument
    for (int i = 0; i < args.length; i++ )
    {
        auto arg = args[i];
        
        if ( skip )
        {
            skip = false;
            continue;
        }
        
        version ( Windows )
          auto tempArg = std.array.replace( arg, "/", "\\" );
        else
          auto tempArg = std.array.replace( arg, "\\", "/" );
        
        if ( std.file.exists( tempArg ) &&
            std.string.icmp( "as", std.path.getExt( tempArg ) ) == 0 )
        {
            // This is probably the file with the entry point.
            // This file, but with a .swf extension, may end up being the
            //   resultant swf filename.  
            // Later on we will check if a previous incantation of this file
            //   exists and make sure it doesn't get included as an asset.  
            if ( resultName is null )
            {
                // guess the result name by changing the extension of the
                //   entry file.
                // If the guess is wrong, the -output switch should catch
                //   it.  
                auto temp = std.path.getBaseName( tempArg );
                auto extension = std.path.getExt( temp );
                if ( extension is null )
                    extension.length = 0;
                temp = temp[0..$ - extension.length]; // chop off the extension
                resultName = temp ~ "swf";
            }
            
            // since this is probably the file with the entry point, we can 
            //   remember what directory it is in and generate the asset file
            //   in that directory later.  This is nice for building projects
            //   where the entry point is not necessary in the same directory
            //   that a3 is being invoked from.  
            mainDir = std.path.getDirName( tempArg );
            
            // pass this file on to mxmlc... it will need it!
            passedArgs ~= arg;
            
            continue;
        }
        
        switch( arg )
        {
            case "-showunused":
                showUnused = true;
                break;
                
            case "-outputtemp":
                outputtemp = true;
                break;
                
            case "--help":
            case "-help":
                printUsage();
                goto done;
                
            case "-NR":
                recursive = false;
                break;
            
            case "-nocompile":
                compile = false;
                break;
            
            case "-compiler.source-path":
            case "-sp":
                
                int j = i;
                
                while ( j < args.length - 1 )
                {
                    j++;
                    auto dirName = args[j];
                    
                    // Make sure it really is a directory.  
                    if ( !std.file.exists( dirName ) || 
                         !std.file.isDir( dirName ) )
                    {
                        if ( j == i+1 )
                            throw new Error( args[i]~" switch must be "
                                "followed by a directory full of files to "
                                "include." );
                        
                        break;
                    }
                    
                    // Add it to the list of top level dirs to search.  
                    rootdirs ~= dirName;
                }
                
                // pass this to mxmlc so it can find all of the source files
                passedArgs ~= args[i..j];
                
                // we handled all of those args, so skip them by incrementing i
                i += j-i-1;
                
                break;
            
            case "-output":
                
                if ( i + 1 == args.length )
                {
                    throw new Error( args[i]~" switch must be "
                                "followed by a valid filename." );
                }
                
                resultName = args[i+1];
                passedArgs ~= arg;
                passedArgs ~= args[i+1];
                
                explicitResultName = true;
                
                break;
            
            default:
                passedArgs ~= arg;
                break;
        }
    }
    
    //---------------------------------------------------------------------
    // Recurse through directories while looking for .as, .png, .jpg, 
    //  .mp3, and .swf files.
    //---------------------------------------------------------------------
    string currentRootDir;
    
    //bool checkFile( string name )
	
	foreach(dir; rootdirs)
	foreach(entry; std.parallelism.parallel(std.file.dirEntries( dir, SpanMode.depth)) )
    {
		auto name = entry.name;
        auto fullName = std.path.join( currentRootDir, name );
        if ( std.file.isFile( fullName ) )
        {
            auto ext = std.path.getExt( name );
            
            // Qoutes are put around fullName if there is a space in 
            //   there that the OS or program might not be able to handle. 
            string enQouteIfSpace( string input )
            {
                if ( std.string.indexOf( input, ' ' ) > -1  )
                    return '"' ~ input ~ '"';
                else
                    return input;
            }
            
            switch(ext)
            {
                case "as":
                    srcFiles ~= enQouteIfSpace( fullName );
					assetsReferenced ~= getAssetReferences(fullName);
                    break;
                /+case "swf":
                    // We aren't interested in previous build results.  
                    if ( std.string.icmp( fullName, 
                            std.path.join( rootdirs[0], resultName ) 
                                        ) == 0 )
                        break;
                +/
                default:
                    foreach( assetExt; assetExts )
                    {
                        if ( std.string.icmp( assetExt, ext ) == 0 )
                            assetFiles ~= fullName;
                    }
                    break;
            }
        }
    }
	
	assetsUsed = cast(string[])assetsReferenced;
	assetsUsed = array(std.algorithm.filter!"a == a"(sort(assetsUsed)));
    
    //---------------------------------------------------------------------
    // Generate assets class
    //---------------------------------------------------------------------
    
    auto assetFile = std.path.join( mainDir, "Assets.as" );
    auto nameCorrectnessRegex = regex("[^_a-zA-Z0-9]");
    
    const nl = std.string.newline;
    //char[] initBody = new char[0];
    auto assets = new char[0];
    auto pastIDs = new string[0];
    
    foreach( asset; assetFiles )
    {
        auto idname = std.path.getBaseName( asset );
        
        // We don't want to include previous builds into this build.
        if ( std.string.icmp( idname, resultName ) == 0 )
            continue;
        //
        
        auto extension = std.path.getExt( idname );
        //writefln( extension );
        if ( extension is null )
            extension.length = 0;
        idname = idname[0..$ - (extension.length+1)]; // chop off the extension
        
		auto m = match( idname, nameCorrectnessRegex);
        if ( !m.empty )
		{
			auto err = "Asset file " ~ nl ~ asset ~ nl ~
                "with name \""~idname~
                "\" does not have a valid name." ~ nl ~
                "The name of an asset must contain only alphabetic characters "
                "(a-z, A-Z), numbers (0-9), or an underscore _.";
				
			
			// For some reason just throwing the error on Win64 does not work.
			// It will not display an error message.  Just a silent crash.
			// So we'll help it out and write the error to stdout too.
			writeln(err);
            throw new Error(err);
		}
        
        // check to make sure that the id is unique.
        // if it isn't, throw an error.  
        foreach( i, pastID; pastIDs )
        {
            if ( std.string.cmp( idname, pastID ) == 0 )
                throw new Error( std.string.format("Resultant IDs for the "
                    "files %s and %s are not unique.  The file names, not "
                    "including path or extension, must be different.  This "
                    "is because the name, not including path or extension, "
                    "is used as the id that can be accessed by actionscript."
                    ,asset,assetFiles[i]) );
        }
        
        // append this to pastIDs so future IDs can check against it.
        pastIDs ~= idname;
        
        if ( std.string.icmp( extension, "ttf" ) != 0 )
        {
            // If this asset isn't used, don't embed it.  
            //  (only valid for things that aren't fonts)
			// This does a binary search on assetsUsed to find out if
			//   assetsUsed contains idname.
			bool used = !assumeSorted(assetsUsed).equalRange(idname).empty;
			
            if ( !used )
                continue;
        }
        
        // prep for the step afterwards - it just makes sure we have an absolute view
        //   of the main entry point directory
        auto absMainDir = mainDir;
        if ( cwd !is mainDir )
            absMainDir = std.path.join( cwd, mainDir );
        
        // try to write asset paths relative to the directory of the main entry point file
        if ( std.string.icmp( cwd, absMainDir[0..cwd.length] ) == 0 )
        {
            // suppose absMainDir = tempDir = "C:\asprojects\game\src\stable"
            // also suppose cwd = "C:\asprojects\game"
            auto tempDir = absMainDir;
            auto backtrack = "";
            
            // if the entry point dir is longer than the cwd, we may need to backtrack to get
            //   to where the asset is.  
            if ( tempDir.length > cwd.length )
            {
                // chop off the cwd part, now tempDir = "src\stable"
                tempDir = tempDir[cwd.length+1 .. $];
            
                // how many directories we need to travel towards the root before we can
                //   move towards the directory containing this asset (how many backtracks)
                // in the current example, this ends up being 2
                int numBacktracks = 0;
                while ( tempDir.length > 0 && tempDir != "." )
                {
                    tempDir = std.path.getDirName( tempDir );
                    numBacktracks++;
                }
                
                // generate a string which tells mxmlc how many backtracks it needs to take
                // in the example, backtrack = "..\..\"
                for ( int i = 0; i < numBacktracks; i++ )
                {
                    backtrack ~= ".." ~ std.path.sep;
                }
            }
            
            // suppose asset = "C:\asprojects\images\base.png"
            // now we slice off the "C:\asprojects" part
            //   thus asset becomes "images\base.png"
            // then we concatenate backtrack on there
            //   and get "..\..\images\base.png"
            // then we are done.  
            asset = backtrack ~ asset[cwd.length+1 .. $];
        }
        
        // the path seperators on windows become escape sequences...
        //   this can be defeated by replacing \ with \\ so that mxmlc actually
        //   sees the path seperators instead of escape characters.  
        auto temp = new char[0];
        foreach( dchar c; asset )
        {
            if ( c == '\\' )
                temp ~= "\\\\";
            else
                temp ~= c;
        }
        asset = temp.idup;
		
        // Add the embed tag.  
        if ( std.string.icmp( extension, "ttf" ) == 0 )
        {
          assets ~= std.string.format(
             `        [Embed(source="%s", fontName="%s")]` ~ nl ~
             `        public static var %s:Class;` ~ nl,
              asset, idname,
              idname ~ "_dummy" );
        }
        else
        {
          assets ~= std.string.format(
             `        [Embed(source="%s")]` ~ nl ~
             `        public static var %s:Class;` ~ nl,
              asset,
              idname );
        }
        
        /+char[] extTypeString = null;
        
        switch( extType( extension ) )
        {
            case SWF: extTypeString = "MovieClip"; break;
            case IMAGE: extTypeString = "Bitmap"; break;
            case SOUND: extTypeString = "Sound"; break;
            case FONT: extTypeString = "Font"; break;
            default: break;
        }
        
        if ( extTypeString !is null )
        {
            assets ~= std.string.format(
                nl ~ `        public static var %s:%s;` ~ nl,
                idname,
                extTypeString );
            initBody ~= std.string.format(
                `            %s = new %s();` ~ nl,
                idname, idname ~ "_class" );
        }+/
    }
    
    auto initializer = std.string.format
    (
        `
        public static function init(_root:Sprite) : void
        {
            root = _root;
        }`
        //,initBody
    );
    
    auto assetClass = std.string.format
    (
`package {

import flash.display.Bitmap;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.media.Sound;
import flash.text.Font;

    public class Assets
    {
        public static var root : Sprite;
    
%s
%s
    }

}`
        ,assets
        ,initializer
    );
    
    std.file.write( assetFile, cast(void[])assetClass );
    
    //---------------------------------------------------------------------
    // Call MXMLC
    //---------------------------------------------------------------------
    
    if ( compile )
    {
        auto mxmlcArgs = "";
        
        foreach( arg; passedArgs )
            mxmlcArgs ~= " " ~ arg;
        
        delete passedArgs; // so the gc doesn't have to.  
        
        mxmlcArgs ~= defaultArgs;
        
        debug writefln( "Compiling with args " ~ mxmlcArgs );
        
        std.datetime.StopWatch timer;
        
        timer.start();
        // For some reason std.process.execvp would make this app exit early.  
        int exitStatus = std.process.system( "mxmlc" ~ mxmlcArgs );
        
        timer.stop();
        writefln( "Compilation took %s microseconds.", timer.peek.usecs );
        
        if ( exitStatus != 0 )
            return exitStatus;
    }
    
    //---------------------------------------------------------------------
    // Cleanup temporary Assets file and quit.  
    //---------------------------------------------------------------------
    
    if ( !outputtemp )
        std.file.remove( assetFile );
    
    //---------------------------------------------------------------------
    // If mainDir and cwd aren't the same, we want to move the swf
    //---------------------------------------------------------------------
    
    if ( compile )
    {
        if ( !std.path.isabs( mainDir ) )
            mainDir = std.path.join( cwd, mainDir );
        
        if ( resultName !is null && !explicitResultName && 
             std.string.icmp( mainDir, cwd ) != 0 )
        {
            std.file.copy( std.path.join( mainDir, resultName ), 
                           std.path.join( cwd, resultName ) );
            std.file.remove( std.path.join( mainDir, resultName ) );
        }
    }
    
    //---------------------------------------------------------------------
    // Find unused assets, if applicable
    //---------------------------------------------------------------------
    
    if ( showUnused )
    {
        shared assetsUnused = cast(shared)(new string[0]);
        
        //bool checkAsset( string name )
		foreach(dir; rootdirs)
		foreach(entry; std.parallelism.parallel(std.file.dirEntries( dir, SpanMode.depth)) )
        {
			auto name = entry.name;
            auto fullName = std.path.join( currentRootDir, name );
            if ( std.file.isFile( fullName ) )
            {
                auto ext = std.path.getExt( name );
                
                // Qoutes are put around fullName if there is a space in 
                //   there that the OS or program might not be able to handle. 
                string enQouteIfSpace( string input )
                {
                    if ( std.string.indexOf( input, ' ' ) > -1  )
                        return '"' ~ input ~ '"';
                    else
                        return input;
                }
                
                foreach( assetExt; assetExts )
                {
                    if ( std.string.icmp( assetExt, ext ) == 0 &&
                         std.string.icmp( assetExt, "ttf" ) != 0 )
                    {
                        bool isUsed = false;
                        foreach( usedAsset; assetsUsed )
                        {
                            auto idname = std.path.getBaseName( name );
                            idname = idname[0..$ - (assetExt.length+1)];
                            
                            if ( std.string.icmp( idname, usedAsset ) == 0 )
                                isUsed = true;
                        }
                        
                        if ( !isUsed )
                          assetsUnused ~= fullName;
                    }
                }
            }
        }
        
        writefln( "Assets unused: ");
        foreach( asset; assetsUnused )
            writefln( asset );
    }
    // Done!
    
    done:
    return 0;
}

bool contains( immutable string[] stringSet, string str )
{
    foreach( subString; stringSet )
        if ( std.string.icmp( subString, str ) == 0 )
            return true;
    
    return false;
}

string[] getAssetReferences( string srcFile )
{
    auto code = cast(string)std.file.read( srcFile );
    auto assets = match( code, fileRegExp );
    auto newAssetsUsed = new string[0];
	
    foreach( asset; assets )
        newAssetsUsed ~= asset.hit[7..$-1]; // Assets.whatever -> whatever
    
    return newAssetsUsed;
}

void printUsage()
{
    char[] extensions = new char[0];
    
    foreach( ext; assetExts )
        extensions ~= "    " ~ext ~ std.string.newline;
    
    writefln( usage ~ extensions );
    
    delete extensions;
}

const char[] usage = `
Actionscript 3 builder:
This program will recursively search all files and folders starting at the 
level it is run from, and collect action script files and any content like 
images and music.  It will then form a complete .swf file.  
It works like so:
1) Find all of the assets like image and sound files.
2) Generate Assets.as which is used to tell mxmlc to embed the image and sound
     files.  
3) Invoke mxmlc.  

Usage:
a3 <Entry File> <options>
    -compiler.source-path <dirname>
    -sp <dirname>
        Includes files within <dirname> while searching for files to include in
        the project.  These arguments and the directories will be passed to 
        mxmlc, since it uses them to search for source files.  
    -NR
        Do not search directories recursively.  (By default directories ARE 
        searched recursively)
    -nocompile
        Do not call MXMLC or build, just form the asset file and maybe show 
        unused assets.  
    -outputtemp
        Do not delete the temp files used in the build process.  
    -showunused
        After building, display all asset files not used by a3.  
    --help
    -help
        Prints this.  

All other parameters are passed to MXMLC in the compilation process.  

Other Notes:
- All assets found must have unique file names, even accross different paths 
    and extensions.  The ID name of the asset will be the same as the name of 
    the file found, minus the path and the extension.
    Example: "C:\somedir\picture.png" will be imported as "picture"
- a3 currently supports the following asset types:
    jpg, jpeg, png, gif, mp3, ttf
- Currently a3 does not embed swfs in the Assets file, since they require 
    symbols to be defined which require knowledge about the insides of the 
    swf.  It does not even look at swfs or consider them assets at all.  
- Text files will be embedded in such a way that their name will be the 
    string given to a TextField .font property.
    For example, if the font file is called "foobar.ttf", the code
    to use it goes like so:
    
    // Example
    var myTextField : TextField = new TextField();
    // add text to the textfield here
    
    var tf : TextFormat = new TextFormat();
    tf.font = "foobar";
    
    myTextField.setTextFormat(tf);
    // end of example.  
`;
