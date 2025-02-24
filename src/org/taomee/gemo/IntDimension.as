package org.taomee.gemo
{
   public class IntDimension
   {
      private var _height:int = 0;
      
      private var _width:int = 0;
      
      public function IntDimension(w:int = 0, h:int = 0)
      {
         super();
         _width = w;
         _height = h;
      }
      
      public function setSize(dim:IntDimension) : void
      {
         _width = dim.width;
         _height = dim.height;
      }
      
      public function setSizeWH(w:int, h:int) : void
      {
         _width = w;
         _height = h;
      }
      
      public function set height(i:int) : void
      {
         _height = i;
      }
      
      public function set width(i:int) : void
      {
         _width = i;
      }
      
      public function get width() : int
      {
         return _width;
      }
      
      public function get height() : int
      {
         return _height;
      }
   }
}

