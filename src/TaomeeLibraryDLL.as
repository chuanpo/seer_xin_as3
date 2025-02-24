package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   public class TaomeeLibraryDLL extends Sprite
   {
      public function TaomeeLibraryDLL()
      {
         super();
         Security.allowDomain("*.61.com");
      }
   }
}

