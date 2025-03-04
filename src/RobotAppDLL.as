package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   public class RobotAppDLL extends Sprite
   {
      public function RobotAppDLL()
      {
         try
         {
            Security.allowDomain("*");
            Security.allowInsecureDomain("*");
         }
         catch (e:SecurityError)
         {
            trace("Security.allowDomain 或 Security.allowInsecureDomain 失败: " + e.message);
         }
         super();
      }
   }
}
