package org.taomee.display
{
   import flash.display.Bitmap;
   
   public class ExtBitmapPlayer extends Bitmap
   {
      private var _totalFrames:uint;
      
      private var _bitmapList:Array = [];
      
      private var _currentFrame:uint;
      
      public function ExtBitmapPlayer(dataList:Array = null)
      {
         super();
         if(Boolean(dataList))
         {
            this.dataList = dataList;
         }
      }
      
      public function destroy(gc:Boolean = false) : void
      {
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
      
      public function set currentFrame(frame:uint) : void
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
         bitmapData = _bitmapList[_currentFrame];
      }
      
      public function get totalFrames() : uint
      {
         return _totalFrames;
      }
      
      public function clear() : void
      {
         bitmapData = null;
         _totalFrames = 0;
         _currentFrame = 0;
         _bitmapList = [];
      }
      
      public function set dataList(value:Array) : void
      {
         if(value == null)
         {
            clear();
            return;
         }
         _bitmapList = value;
         _totalFrames = _bitmapList.length;
         _currentFrame = 0;
         bitmapData = _bitmapList[_currentFrame];
      }
      
      public function get currentFrame() : uint
      {
         return _currentFrame;
      }
      
      public function nextFrame() : void
      {
         if(_totalFrames > 1)
         {
            bitmapData = _bitmapList[_currentFrame];
            ++_currentFrame;
            if(_currentFrame == _totalFrames)
            {
               _currentFrame = 0;
            }
         }
      }
   }
}

