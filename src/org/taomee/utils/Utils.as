package org.taomee.utils
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.media.Sound;
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class Utils
   {
      private static var _bmdPacket:Dictionary = new Dictionary(true);
      
      public function Utils()
      {
         super();
      }
      
      public static function getClass(name:String) : Class
      {
         var ClassReference:Class = null;
         try
         {
            ClassReference = getDefinitionByName(name) as Class;
         }
         catch(e:Error)
         {
            trace("getClass " + name + "error" + e.message);
            return null;
         }
         return ClassReference;
      }
      
      public static function getClassFromLoader(name:String, loader:Loader) : Class
      {
         var app:ApplicationDomain = loader.contentLoaderInfo.applicationDomain;
         if(app.hasDefinition(name))
         {
            return app.getDefinition(name) as Class;
         }
         trace("Utils getClassFromLoader not hasDefinition:" + name);
         return null;
      }
      
      public static function getMovieClipFromLoader(name:String, loader:Loader) : MovieClip
      {
         var r:DisplayObject = getDisplayObjectFromLoader(name,loader);
         return r == null ? null : r as MovieClip;
      }
      
      public static function getDisplayObjectFromLoader(name:String, loader:Loader) : DisplayObject
      {
         var classReference:Class = getClassFromLoader(name,loader);
         if(classReference != null)
         {
            try
            {
               return new classReference() as DisplayObject;
            }
            catch(e:Error)
            {
               trace("Utils getDisplayObjectFromLoader error:" + e.toString());
               return null;
            }
         }
         else
         {
            return null;
         }
      }
      
      public static function getBitmapDataFromLoader(name:String, loader:Loader, isCache:Boolean = false) : BitmapData
      {
         var classReference:Class;
         var bmd:BitmapData = null;
         if(Boolean(_bmdPacket[name]))
         {
            return _bmdPacket[name];
         }
         classReference = getClassFromLoader(name,loader);
         if(Boolean(classReference))
         {
            try
            {
               bmd = new classReference(0,0) as BitmapData;
            }
            catch(e:Error)
            {
               trace("Utils getBitmapDataFromLoader error:" + e.toString());
            }
            if(isCache)
            {
               if(Boolean(bmd))
               {
                  _bmdPacket[name] = bmd;
               }
            }
            return bmd;
         }
         return null;
      }
      
      public static function getLoaderClass(loader:Loader) : Class
      {
         return loader.contentLoaderInfo.applicationDomain.getDefinition(getQualifiedClassName(loader.content)) as Class;
      }
      
      public static function getSoundFromLoader(name:String, loader:Loader) : Sound
      {
         var classReference:Class = getClassFromLoader(name,loader);
         return new classReference() as Sound;
      }
      
      public static function getSimpleButtonFromLoader(name:String, loader:Loader) : SimpleButton
      {
         var r:DisplayObject = getDisplayObjectFromLoader(name,loader);
         return r == null ? null : r as SimpleButton;
      }
      
      public static function getSpriteFromLoader(name:String, loader:Loader) : Sprite
      {
         var r:DisplayObject = getDisplayObjectFromLoader(name,loader);
         return r == null ? null : r as Sprite;
      }
      
      public static function getClassByObject(obj:DisplayObject) : Class
      {
         var mcs:Class = null;
         try
         {
            mcs = getClassFromLoader(getQualifiedClassName(obj),obj.loaderInfo.loader) as Class;
         }
         catch(e:Error)
         {
            trace("getClass " + obj.toString() + "error" + e.message);
            return null;
         }
         return mcs;
      }
   }
}

