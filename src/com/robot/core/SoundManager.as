package com.robot.core
{
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.map.MapLibManager;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class SoundManager
   {
      private static var soundChannel:SoundChannel;
      
      private static var currentSound:Sound;
      
      private static var dict:Dictionary = new Dictionary();
      
      public static var isPlay_b:Boolean = true;
      
      init();
      
      public function SoundManager()
      {
         super();
      }
      
      public static function playSound() : void
      {
         var sound:Sound = null;
         var tr:SoundTransform = new SoundTransform(0.2);
         if(isPlay_b == true)
         {
            sound = dict["map_" + MainManager.actorInfo.mapID];
            if(Boolean(sound))
            {
               if(getQualifiedClassName(sound) == getQualifiedClassName(currentSound))
               {
                  return;
               }
               if(Boolean(soundChannel))
               {
                  soundChannel.stop();
               }
               soundChannel = sound.play(0,999999,tr);
               currentSound = sound;
            }
            else
            {
               stopSound();
               try
               {
                  soundChannel = MapLibManager.getSound("sound").play(0,999999,tr);
               }
               catch(e:Error)
               {
               }
            }
         }
      }
      
      public static function stopSound() : void
      {
         if(Boolean(soundChannel))
         {
            soundChannel.stop();
         }
         currentSound = null;
      }
      
      private static function init() : void
      {
         add(KLS_Sound,10,11,12);
         add(HS_Sound,15);
         add(HY_Sound,20,21,22);
         add(YX_Sound,25,26,27);
         add(HEK_Sound,30);
      }
      
      private static function add(sound:Class, ... args) : void
      {
         var i:uint = 0;
         for each(i in args)
         {
            dict["map_" + i] = new sound() as Sound;
         }
      }
      
      public static function set setIsPlay(b1:Boolean) : void
      {
         isPlay_b = b1;
      }
      
      public static function get getIsPlay() : Boolean
      {
         return isPlay_b;
      }
   }
}

