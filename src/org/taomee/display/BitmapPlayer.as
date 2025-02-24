package org.taomee.display
{
   import flash.display.Bitmap;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class BitmapPlayer extends Bitmap
   {
      private var _delay:uint = 40;
      
      private var _timeID:uint;
      
      private var _totalFrames:uint;
      
      private var _bitmapList:Array = [];
      
      private var _currentFrame:uint;
      
      private var _playing:Boolean;
      
      private var _repeatCount:uint;
      
      private var _currentCount:uint;
      
      public function BitmapPlayer(delay:uint = 40, repeatCount:uint = 0)
      {
         super();
         _delay = delay;
         _repeatCount = repeatCount;
      }
      
      public function stop() : void
      {
         clearInterval(_timeID);
         _playing = false;
      }
      
      public function get delay() : uint
      {
         return _delay;
      }
      
      public function set delay(value:uint) : void
      {
         _delay = value;
         clearInterval(_timeID);
         if(_totalFrames > 1)
         {
            _timeID = setInterval(onEnter,_delay);
         }
      }
      
      public function get totalFrames() : uint
      {
         return _totalFrames;
      }
      
      public function clear() : void
      {
         stop();
         bitmapData = null;
         _totalFrames = 0;
         _currentFrame = 0;
         _bitmapList = [];
         _currentCount = 0;
      }
      
      public function gotoAndPlay(frame:uint) : void
      {
         if(frame > _totalFrames - 1)
         {
            frame = uint(_totalFrames - 1);
         }
         if(frame < 0)
         {
            return;
         }
         _currentFrame = frame;
         if(!_playing)
         {
            play();
         }
      }
      
      public function set dataList(value:Array) : void
      {
         if(value == null)
         {
            clear();
            return;
         }
         stop();
         _bitmapList = value;
         _totalFrames = _bitmapList.length;
         _currentFrame = 0;
         _currentCount = 0;
         bitmapData = _bitmapList[_currentFrame];
      }
      
      public function gotoAndStop(frame:uint) : void
      {
         if(frame > _totalFrames - 1)
         {
            frame = uint(_totalFrames - 1);
         }
         if(frame < 0)
         {
            return;
         }
         stop();
         _currentFrame = frame;
         bitmapData = _bitmapList[_currentFrame];
      }
      
      public function play() : void
      {
         _playing = true;
         clearInterval(_timeID);
         if(_totalFrames > 1)
         {
            _timeID = setInterval(onEnter,_delay);
         }
         onEnter();
      }
      
      public function set repeatCount(value:uint) : void
      {
         _repeatCount = value;
      }
      
      public function get playing() : Boolean
      {
         return _playing;
      }
      
      public function get currentFrame() : uint
      {
         return _currentFrame;
      }
      
      private function onEnter() : void
      {
         bitmapData = _bitmapList[_currentFrame];
         ++_currentFrame;
         if(_currentFrame == _totalFrames)
         {
            _currentFrame = 0;
            if(_repeatCount != 0)
            {
               ++_currentCount;
               if(_currentCount == _repeatCount)
               {
                  stop();
               }
            }
         }
      }
      
      public function destroy(gc:Boolean = false) : void
      {
         stop();
         if(gc)
         {
            _bitmapList.forEach(function(item:*, index:int, array:Array):void
            {
               if(item)
               {
                  item.dispose();
               }
            });
         }
         bitmapData = null;
         _bitmapList = null;
      }
      
      public function get repeatCount() : uint
      {
         return _repeatCount;
      }
   }
}

