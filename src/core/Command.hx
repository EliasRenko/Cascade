package core;

import sys.io.File;
import sys.FileStat;
import debug.Logger;
import sys.FileSystem;
import haxe.Exception;
import haxe.ds.Option;

class Command {

    private var __project:Project;

    public function new(project:Project) {
        
        __project = project;
    }

    public function run(args:Array<String>):Option<Exception> {

        return None;
    }

    private function copy(_assetsDirectory:String):Bool {
        
        if (FileSystem.exists(_assetsDirectory)) {

            if (!FileSystem.isDirectory(_assetsDirectory)) {

                Logger.print('Assigned asset folder: ' + __project.resourcePath + ', is missing.');
            }
        }
        else {

            Logger.print('Assigned asset folder: ' + __project.resourcePath + ', is missing.');

            return false;
        }

        var _assetsFolders:Array<String> = FileSystem.readDirectory(__project.path + __project.resourcePath);

        for (i in 0..._assetsFolders.length) {

            var currentDir:String = __project.path + __project.resourcePath + '/' + _assetsFolders[i];

            if (FileSystem.isDirectory(currentDir)) {

                if (!FileSystem.exists(__project.path + 'bin/' + __directoryName + '/' + __project.resourcePath + '/' + _assetsFolders[i])) {

                    FileSystem.createDirectory(__project.path + 'bin/' + __directoryName + '/' + __project.resourcePath + '/' + _assetsFolders[i]);
                }

                var files:Array<String> = FileSystem.readDirectory(currentDir);

                for (j in 0...files.length) {

                    if (!FileSystem.isDirectory(currentDir + '/' + files[j])) {

                        var _destFile:String = __project.path + 'bin/' + __directoryName + '/' + __project.resourcePath + '/' + _assetsFolders[i] + '/' + files[j];

                        var _sourceFileStat:FileStat = FileSystem.stat(currentDir + '/' + files[j]);

                        if (FileSystem.exists(_destFile)) {

                            var _destFileStat:FileStat = FileSystem.stat(_destFile);

                            if(!(_sourceFileStat.mtime.getTime() > _destFileStat.mtime.getTime())) {

                                continue;
                            }
                        }
                        
                        File.copy(currentDir + '/' + files[j], _destFile);
                    }
                }
            }
        }
    }

    private function copyResources(project:Project, __directoryName:String):Bool {
        
        var _assetsDirectory:String = __project.path + __project.resourcePath;

        if (FileSystem.exists(_assetsDirectory)) {

            if (!FileSystem.isDirectory(_assetsDirectory)) {

                Logger.print('Assigned asset folder: ' + __project.resourcePath + ', is missing.');
            }
        }
        else {

            Logger.print('Assigned asset folder: ' + __project.resourcePath + ', is missing.');

            return false;
        }

        var _assetsFolders:Array<String> = FileSystem.readDirectory(__project.path + __project.resourcePath);

        for (i in 0..._assetsFolders.length) {

            var currentDir:String = __project.path + __project.resourcePath + '/' + _assetsFolders[i];

            if (FileSystem.isDirectory(currentDir)) {

                if (!FileSystem.exists(__project.path + 'bin/' + __directoryName + '/' + __project.resourcePath + '/' + _assetsFolders[i])) {

                    FileSystem.createDirectory(__project.path + 'bin/' + __directoryName + '/' + __project.resourcePath + '/' + _assetsFolders[i]);
                }

                var files:Array<String> = FileSystem.readDirectory(currentDir);

                for (j in 0...files.length) {

                    if (!FileSystem.isDirectory(currentDir + '/' + files[j])) {

                        var _destFile:String = __project.path + 'bin/' + __directoryName + '/' + __project.resourcePath + '/' + _assetsFolders[i] + '/' + files[j];

                        var _sourceFileStat:FileStat = FileSystem.stat(currentDir + '/' + files[j]);

                        if (FileSystem.exists(_destFile)) {

                            var _destFileStat:FileStat = FileSystem.stat(_destFile);

                            if(!(_sourceFileStat.mtime.getTime() > _destFileStat.mtime.getTime())) {

                                continue;
                            }
                        }
                        
                        File.copy(currentDir + '/' + files[j], _destFile);
                    }
                }
            }
        }

        return true;
    }
}