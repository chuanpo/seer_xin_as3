package gs.utils.tween
{
   import flash.geom.Point;
   
   public class TransformAroundPointVars extends SubVars
   {
      public function TransformAroundPointVars($point:Point = null, $scaleX:Number = NaN, $scaleY:Number = NaN, $rotation:Number = NaN, $width:Number = NaN, $height:Number = NaN, $shortRotation:Object = null, $x:Number = NaN, $y:Number = NaN)
      {
         super();
         if($point != null)
         {
            this.point = $point;
         }
         if(!isNaN($scaleX))
         {
            this.scaleX = $scaleX;
         }
         if(!isNaN($scaleY))
         {
            this.scaleY = $scaleY;
         }
         if(!isNaN($rotation))
         {
            this.rotation = $rotation;
         }
         if(!isNaN($width))
         {
            this.width = $width;
         }
         if(!isNaN($height))
         {
            this.height = $height;
         }
         if($shortRotation != null)
         {
            this.shortRotation = $shortRotation;
         }
         if(!isNaN($x))
         {
            this.x = $x;
         }
         if(!isNaN($y))
         {
            this.y = $y;
         }
      }
      
      public static function createFromGeneric($vars:Object) : TransformAroundPointVars
      {
         if($vars is TransformAroundPointVars)
         {
            return $vars as TransformAroundPointVars;
         }
         return new TransformAroundPointVars($vars.point,$vars.scaleX,$vars.scaleY,$vars.rotation,$vars.width,$vars.height,$vars.shortRotation,$vars.x,$vars.y);
      }
      
      public function set point($p:Point) : void
      {
         this.exposedVars.point = $p;
      }
      
      public function set scaleX($n:Number) : void
      {
         this.exposedVars.scaleX = $n;
      }
      
      public function set scaleY($n:Number) : void
      {
         this.exposedVars.scaleY = $n;
      }
      
      public function get width() : Number
      {
         return Number(this.exposedVars.width);
      }
      
      public function get height() : Number
      {
         return Number(this.exposedVars.height);
      }
      
      public function get scale() : Number
      {
         return Number(this.exposedVars.scale);
      }
      
      public function set width($n:Number) : void
      {
         this.exposedVars.width = $n;
      }
      
      public function get scaleX() : Number
      {
         return Number(this.exposedVars.scaleX);
      }
      
      public function get scaleY() : Number
      {
         return Number(this.exposedVars.scaleY);
      }
      
      public function get point() : Point
      {
         return this.exposedVars.point;
      }
      
      public function set y($n:Number) : void
      {
         this.exposedVars.y = $n;
      }
      
      public function set scale($n:Number) : void
      {
         this.exposedVars.scale = $n;
      }
      
      public function set height($n:Number) : void
      {
         this.exposedVars.height = $n;
      }
      
      public function set x($n:Number) : void
      {
         this.exposedVars.x = $n;
      }
      
      public function get x() : Number
      {
         return Number(this.exposedVars.x);
      }
      
      public function get y() : Number
      {
         return Number(this.exposedVars.y);
      }
      
      public function get shortRotation() : Object
      {
         return this.exposedVars.shortRotation;
      }
      
      public function set shortRotation($o:Object) : void
      {
         this.exposedVars.shortRotation = $o;
      }
      
      public function set rotation($n:Number) : void
      {
         this.exposedVars.rotation = $n;
      }
      
      public function get rotation() : Number
      {
         return Number(this.exposedVars.rotation);
      }
   }
}

