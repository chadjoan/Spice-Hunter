// This is the Actionscript 3 builder by Chad Joan

import std.file;
import std.path;
import std.conv;
import std.string;
import std.stdio;
import std.process;
import std.thread;
import std.regexp;
import std.perf;

const char[] defaultArgs = " -default-size 800 600";

const char[][] assetExts =
[
"swf a!!!", // this is gone

// some sorta vector graphic format
"svg",

// image types
"jpg",
"jpeg",
"png",
"gif",

// sound files
"mp3",

// font file(s)
"ttf",
];

char[][] swfExts;
char[][] imageExts;
char[][] soundExts;
char[][] fontExts;

static RegExp fileRegExp;

static this()
{
    swfExts = assetExts[0..1];
    imageExts = assetExts[2..6];
    soundExts = assetExts[6..7];
    fontExts = assetExts[7..8];
    
    fileRegExp = new RegExp( "Assets[.][_A-Za-z].*?[^_A-Za-z0-9]", "g" );
}

enum // extension type
{
    SWF,
    IMAGE,
    SOUND,
    FONT
}

uint extType( char[] extension )
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
}

int main( char[][] args )
{
    // if this ever needs optimizing, 
    // linked lists would probably be much faster for some of this stuff
    char[][] srcFiles = new char[][0];
    char[][] assetFiles = new char[][0];
    char[][] assetsUsed = new char[][0];
    char[][] rootdirs = new char[][1]; // one for the cwd
    char[][] passedArgs = new char[][0];
    char[] cwd = std.file.getcwd();
    char[] mainDir = cwd;
    char[] resultName = null;
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
        char[] arg = args[i];
        
        if ( skip )
        {
            skip = false;
            continue;
        }
        
        version ( Windows )
          char[] tempArg = std.string.replace( arg, "/", "\\" );
        else
          char[] tempArg = std.string.replace( arg, "\\", "/" );
        
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
                char[] temp = std.path.getBaseName( tempArg );
                char[] extension = std.path.getExt( temp );
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
                    char[] dirName = args[j];
                    
                    // Make sure it really is a directory.  
                    if ( !std.file.exists( dirName ) || 
                         !std.file.isdir( dirName ) )
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
    char[] currentRootDir;
    
    bool checkFile( char[] name )
    {
        char[] fullName = std.path.join( currentRootDir, name );
        if ( std.file.isfile( fullName ) )
        {
            char[] ext = std.path.getExt( name );
            
            // Qoutes are put around fullName if there is a space in 
            //   there that the OS or program might not be able to handle. 
            char[] enQouteIfSpace( char[] input )
            {
                if ( std.string.find( input, ' ' ) > -1  )
                    return '"' ~ input ~ '"';
                else
                    return input;
            }
            
            switch(ext)
            {
                case "as":
                    srcFiles ~= enQouteIfSpace( fullName );
                    searchForAssetUsage( fullName, assetsUsed );
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
        else if ( recursive && std.file.isdir( fullName ) )
        {
            // Backup the current path, then add the branch on the end.  
            char[] temp = currentRootDir.dup;
            currentRootDir = fullName;
            
            // Recurse into the next dir.
            std.file.listdir( fullName, &checkFile );
            
            // Clean up, and restore the path before we went on that tangent.
            delete currentRootDir;
            currentRootDir = temp;
        }
        
        return true; // Continue to the next file.  
    }
    
    foreach( dir; rootdirs )
    {
        currentRootDir = dir;
        std.file.listdir( dir, &checkFile );
    }
    
    //---------------------------------------------------------------------
    // Generate assets class
    //---------------------------------------------------------------------
    
    char[] assetFile = std.path.join( mainDir, "Assets.as" );
    auto nameCorrectnessRegex = new RegExp("[^_a-zA-Z0-9]");
    
    //char[] initBody = new char[0];
    char[] assets = new char[0];
    char[] nl = std.string.newline;
    char[][] pastIDs = new char[][0];
    
    foreach( asset; assetFiles )
    {
        char[] idname = std.path.getBaseName( asset );
        
        // We don't want to include previous builds into this build.
        if ( std.string.icmp( idname, resultName ) == 0 )
            continue;
        //
        
        char[] extension = std.path.getExt( idname );
        //writefln( extension );
        if ( extension is null )
            extension.length = 0;
        idname = idname[0..$ - (extension.length+1)]; // chop off the extension
        
        if ( nameCorrectnessRegex.find( idname ) >= 0 )
            throw new Error( "Asset file " ~ nl ~ asset ~ nl ~
                "with name \""~idname~
                "\" does not have a valid name." ~ nl ~
                "The name of an asset must contain only alphabetic characters "
                "(a-z, A-Z), numbers (0-9), or an underscore _." );
        
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
            bool used = false;
            foreach( assetUsed; assetsUsed )
            {
                if ( std.string.cmp( idname, assetUsed ) == 0 )
                    used = true;
            }
            if ( !used )
                continue;
        }
        
        // prep for the step afterwards - it just makes sure we have an absolute view
        //   of the main entry point directory
        char[] absMainDir = mainDir;
        if ( cwd !is mainDir )
            absMainDir = std.path.join( cwd, mainDir );
        
        // try to write asset paths relative to the directory of the main entry point file
        if ( std.string.icmp( cwd, absMainDir[0..cwd.length] ) == 0 )
        {
            // suppose absMainDir = tempDir = "C:\asprojects\game\src\stable"
            // also suppose cwd = "C:\asprojects\game"
            char[] tempDir = absMainDir;
            char[] backtrack = "";
            
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
                while ( tempDir.length > 0 )
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
        char[] temp = new char[0];
        foreach( dchar c; asset )
        {
            if ( c == '\\' )
                temp ~= "\\\\";
            else
                temp ~= c;
        }
        asset = temp;
        
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
    
    char[] initializer = std.string.format
    (
        `
        public static function init(_root:Sprite) : void
        {
            root = _root;
        }`
        //,initBody
    );
    
    char[] assetClass = std.string.format
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
        char[] mxmlcArgs = new char[0];
        
        foreach( arg; passedArgs )
            mxmlcArgs ~= " " ~ arg;
        
        delete passedArgs; // so the gc doesn't have to.  
        
        mxmlcArgs ~= defaultArgs;
        
        debug writefln( "Compiling with args " ~ mxmlcArgs );
        
        auto timer = new std.perf.PerformanceCounter();
        
        timer.start();
        // For some reason std.process.execvp would make this app exit early.  
        int exitStatus = std.process.system( "mxmlc" ~ mxmlcArgs );
        
        timer.stop();
        writefln( "Compilation took ", timer.microseconds," microseconds." );
        
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
        char[][] assetsUnused = new char[][0];
        
        bool checkAsset( char[] name )
        {
            char[] fullName = std.path.join( currentRootDir, name );
            if ( std.file.isfile( fullName ) )
            {
                char[] ext = std.path.getExt( name );
                
                // Qoutes are put around fullName if there is a space in 
                //   there that the OS or program might not be able to handle. 
                char[] enQouteIfSpace( char[] input )
                {
                    if ( std.string.find( input, ' ' ) > -1  )
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
                            char[] idname = std.path.getBaseName( name );
                            idname = idname[0..$ - (assetExt.length+1)];
                            
                            if ( std.string.icmp( idname, usedAsset ) == 0 )
                                isUsed = true;
                        }
                        
                        if ( !isUsed )
                          assetsUnused ~= fullName;
                    }
                }
            }
            else if ( recursive && std.file.isdir( fullName ) )
            {
                // Backup the current path, then add the branch on the end.  
                char[] temp = currentRootDir.dup;
                currentRootDir = fullName;
                
                // Recurse into the next dir.
                std.file.listdir( fullName, &checkAsset );
                
                // Clean up, and restore the path before we went on that tangent.
                delete currentRootDir;
                currentRootDir = temp;
            }
            
            return true;
        }
        
        foreach( dir; rootdirs )
        {
            currentRootDir = dir;
            std.file.listdir( dir, &checkAsset );
        }
        
        writefln( "Assets unused: ");
        foreach( asset; assetsUnused )
            writefln( asset );
    }
    // Done!
    
    done:
    return 0;
}

bool contains( char[][] stringSet, char[] string )
{
    foreach( subString; stringSet )
        if ( std.string.icmp( subString, string ) == 0 )
            return true;
    
    return false;
}

bool searchForAssetUsage( char[] srcFile, inout char[][] assetsUsedList )
{
    char[] code = cast(char[])std.file.read( srcFile );
    char[][] assets = fileRegExp.match(code);
    char[][] newAssetsUsed = new char[][0];
    
    foreach( asset; assets )
    {
        asset = asset[7..$-1]; // Assets.whatever -> whatever
        bool duplicate = false;
        foreach( assetUsed; assetsUsedList )
        {
            if ( std.string.cmp( asset, assetUsed ) == 0 )
                duplicate = true;
        }
        if ( !duplicate )
            newAssetsUsed ~= asset.dup;
    }
    
    delete code;
    
    assetsUsedList ~= newAssetsUsed;
    if ( newAssetsUsed.length > 0 )
      return true;
    
    return false;
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
