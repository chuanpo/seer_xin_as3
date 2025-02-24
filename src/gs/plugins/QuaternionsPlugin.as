package gs.plugins
{
   import gs.*;
   
   public class QuaternionsPlugin extends TweenPlugin
   {
      public static const VERSION:Number = 1;
      
      public static const API:Number = 1;
      
      protected static const _RAD2DEG:Number = 180 / Math.PI;
      
      protected var _target:Object;
      
      protected var _quaternions:Array = [];
      
      public function QuaternionsPlugin()
      {
         super();
         this.propName = "quaternions";
         this.overwriteProps = [];
      }
      
      override public function killProps($lookup:Object) : void
      {
         for(var i:int = _quaternions.length - 1; i > -1; i--)
         {
            if($lookup[_quaternions[i][1]] != undefined)
            {
               _quaternions.splice(i,1);
            }
         }
         super.killProps($lookup);
      }
      
      override public function set changeFactor($n:Number) : void
      {
         var i:int = 0;
         var q:Array = null;
         var scale:Number = NaN;
         var invScale:Number = NaN;
         for(i = _quaternions.length - 1; i > -1; i--)
         {
            q = _quaternions[i];
            if(q[10] + 1 > 0.000001)
            {
               if(1 - q[10] >= 0.000001)
               {
                  scale = Math.sin(q[11] * (1 - $n)) * q[12];
                  invScale = Math.sin(q[11] * $n) * q[12];
               }
               else
               {
                  scale = 1 - $n;
                  invScale = $n;
               }
            }
            else
            {
               scale = Math.sin(Math.PI * (0.5 - $n));
               invScale = Math.sin(Math.PI * $n);
            }
            q[0].x = scale * q[2] + invScale * q[3];
            q[0].y = scale * q[4] + invScale * q[5];
            q[0].z = scale * q[6] + invScale * q[7];
            q[0].w = scale * q[8] + invScale * q[9];
         }
      }
      
      override public function onInitTween($target:Object, $value:*, $tween:TweenLite) : Boolean
      {
         var p:String = null;
         if($value == null)
         {
            return false;
         }
         for(p in $value)
         {
            initQuaternion($target[p],$value[p],p);
         }
         return true;
      }
      
      public function initQuaternion($start:Object, $end:Object, $propName:String) : void
      {
         var angle:Number = NaN;
         var q1:Object = null;
         var q2:Object = null;
         var x1:Number = NaN;
         var x2:Number = NaN;
         var y1:Number = NaN;
         var y2:Number = NaN;
         var z1:Number = NaN;
         var z2:Number = NaN;
         var w1:Number = NaN;
         var w2:Number = NaN;
         var theta:Number = NaN;
         q1 = $start;
         q2 = $end;
         x1 = Number(q1.x);
         x2 = Number(q2.x);
         y1 = Number(q1.y);
         y2 = Number(q2.y);
         z1 = Number(q1.z);
         z2 = Number(q2.z);
         w1 = Number(q1.w);
         w2 = Number(q2.w);
         angle = x1 * x2 + y1 * y2 + z1 * z2 + w1 * w2;
         if(angle < 0)
         {
            x1 *= -1;
            y1 *= -1;
            z1 *= -1;
            w1 *= -1;
            angle *= -1;
         }
         if(angle + 1 < 0.000001)
         {
            y2 = -y1;
            x2 = x1;
            w2 = -w1;
            z2 = z1;
         }
         theta = Math.acos(angle);
         _quaternions[_quaternions.length] = [q1,$propName,x1,x2,y1,y2,z1,z2,w1,w2,angle,theta,1 / Math.sin(theta)];
         this.overwriteProps[this.overwriteProps.length] = $propName;
      }
   }
}

