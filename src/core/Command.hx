package core;

import haxe.Exception;
import haxe.ds.Option;
import sys.FileStat;
import sys.FileSystem;
import sys.io.File;

class Command {

    private var __project:Project;

    public function new(project:Project) {
        
        __project = project;
    }

    public function run(args:Array<String>):Option<Exception> {

        return None;
    }

    private function copyResources(srcPath:String, dstPath:String):Void {

        if (FileSystem.exists(dstPath)) {

        }
        else {

            try {

                FileSystem.createDirectory(dstPath);

            } catch(e:Exception) {

                throw 'Cannot create directory `${dstPath}`: ${e}';
            }
        }

        trace(srcPath);

        var _files:Array<String> = FileSystem.readDirectory(srcPath);

        for (file in _files) {

            var _srcFilePath:String = srcPath + '/' + file;

            var _dstFilePath:String = dstPath + '/' + file;

            if (FileSystem.isDirectory(_srcFilePath)) {

                copyResources(_srcFilePath, _dstFilePath);

                continue;
            }

            var _sourceFileStat:FileStat = FileSystem.stat(_srcFilePath);

            if (FileSystem.exists(_dstFilePath)) {

                var _destFileStat:FileStat = FileSystem.stat(_dstFilePath);

                if(_sourceFileStat.mtime.getTime() < _destFileStat.mtime.getTime()) {

                    continue;
                }
            }

            try {

                File.copy(_srcFilePath, _dstFilePath);

            } catch(e:Exception) {

                throw 'Cannot copy file `${_srcFilePath}`: ${e}';
            }
        }
    }

    public function cleanResources(srcPath:String):Void {
        
        var _files:Array<String> = FileSystem.readDirectory(srcPath);

        for (file in _files) {

            var _srcFilePath:String = srcPath + '/' + file;

            if (FileSystem.isDirectory(_srcFilePath)) {

                cleanResources(_srcFilePath);

                try {

                    FileSystem.deleteDirectory(_srcFilePath);
    
                } catch(e:Exception) {
    
                    throw 'Cannot delete directory `${_srcFilePath}`: ${e}';
                }

                continue;
            }

            try {

                FileSystem.deleteFile(_srcFilePath);

            } catch(e:Exception) {

                throw 'Cannot delete file `${_srcFilePath}`: ${e}';
            }
        }
    }
}