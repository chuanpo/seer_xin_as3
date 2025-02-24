package org.taomee.display
{
   import flash.display.Bitmap;
   import flash.events.Event;
   
   public class BitmapFramePlayer extends Bitmap
   {
      public static const END_MOVIE:String = "endMovie";
      
      private var _totalFrames:uint;
      
      private var _bitmapList:Array = [];
      
      private var _currentFrame:uint;
      
      private var _playing:Boolean;
      
      private var _repeatCount:uint;
      
      private var _currentCount:uint;
      
      public function BitmapFramePlayer()
      {
         super();
      }
      
      public function stop() : void
      {
         removeEventListener(Event.ENTER_FRAME,onEnterFrame);
         _playing = false;
      }
      
      public function get repeatCount() : uint
      {
         return _repeatCount;
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
         if(_currentFrame == frame)
         {
            return;
         }
         _currentFrame = frame;
         if(!_playing)
         {
            play();
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
      
      private function onEnterFrame(e:Event) : void
      {
         ++_currentFrame;
         if(_currentFrame == _totalFrames)
         {
            _currentFrame = 0;
            if(_repeatCount != 0)
            {
               ++_currentCount;
               if(_currentCount >= _repeatCount)
               {
                  stop();
                  return;
               }
            }
            dispatchEvent(new Event(END_MOVIE));
         }
         bitmapData = _bitmapList[_currentFrame];
      }
      
      public function set repeatCount(value:uint) : void
      {
         _repeatCount = value;
      }
      
      public function get playing() : Boolean
      {
         return _playing;
      }
      
      public function play() : void
      {
         _playing = true;
         if(_totalFrames > 1)
         {
            addEventListener(Event.ENTER_FRAME,onEnterFrame);
         }
         else
         {
            onEnterFrame(null);
         }
      }
      
      public function destroy(gc:Boolean = false) : void
      {
         stop();
         _totalFrames = 0;
         _currentFrame = 0;
         _currentCount = 0;
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
      
      public function get currentFrame() : uint
      {
         return _currentFrame;
      }
   }
}

