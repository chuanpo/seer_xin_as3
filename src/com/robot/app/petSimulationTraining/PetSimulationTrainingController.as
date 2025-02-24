package com.robot.app.petSimulationTraining
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.PetEvent;
   import com.robot.core.info.pet.PetListInfo;
   import com.robot.core.manager.PetManager;
   import com.robot.core.mode.AppModel;
   import flash.events.Event;
   
   public class PetSimulationTrainingController
   {
      private static var _allExePetInfoA:Array;
      
      private static var _info:PetListInfo;
      
      private static var _choicePetImpersonationPanel:AppModel;
      
      private static var _petExerciseListPanel:AppModel;
      
      private static var _petExercisePanel:AppModel;
      
      public function PetSimulationTrainingController()
      {
         super();
      }
      
      public static function set info(info:PetListInfo) : void
      {
         _info = info;
      }
      
      public static function start() : void
      {
         PetManager.addEventListener(PetEvent.STORAGE_LIST,onListComHandler);
         PetManager.getStorageList();
      }
      
      private static function onListComHandler(e:PetEvent) : void
      {
         PetManager.removeEventListener(PetEvent.STORAGE_LIST,onListComHandler);
         if(PetManager.exePetListMap.length > 0)
         {
            showPetExercisePanel();
         }
         else
         {
            showChoicePetImpersonationPanel();
         }
      }
      
      private static function showChoicePetImpersonationPanel() : void
      {
         if(!_choicePetImpersonationPanel)
         {
            _choicePetImpersonationPanel = new AppModel(ClientConfig.getAppModule("ChoicePetImpersonationPanel"),"正在进入");
            _choicePetImpersonationPanel.setup();
            _choicePetImpersonationPanel.sharedEvents.addEventListener(Event.OPEN,onOpenCoursePanelHandler);
            _choicePetImpersonationPanel.sharedEvents.addEventListener(Event.CLOSE,onCloseCoursePanelHandler);
         }
         if(PetManager.getCanExePetList().length != 0)
         {
            _choicePetImpersonationPanel.init(PetManager.getCanExePetList());
         }
         else
         {
            _choicePetImpersonationPanel.init(PetManager.getBagMap());
         }
         _choicePetImpersonationPanel.show();
      }
      
      private static function onCloseCoursePanelHandler(e:Event) : void
      {
         _choicePetImpersonationPanel.sharedEvents.removeEventListener(Event.CLOSE,onCloseCoursePanelHandler);
         _choicePetImpersonationPanel.sharedEvents.removeEventListener(Event.OPEN,onOpenCoursePanelHandler);
         _choicePetImpersonationPanel.destroy();
         _choicePetImpersonationPanel = null;
      }
      
      private static function onOpenCoursePanelHandler(e:Event) : void
      {
         onCloseCoursePanelHandler(null);
         if(Boolean(e))
         {
            showPetExerciseListPanel();
         }
      }
      
      private static function showPetExerciseListPanel() : void
      {
         if(!_petExerciseListPanel)
         {
            _petExerciseListPanel = new AppModel(ClientConfig.getAppModule("PetExerciseListPanel"),"正在进入");
            _petExerciseListPanel.setup();
            _petExerciseListPanel.sharedEvents.addEventListener(Event.OPEN,onOpenExeingPanelHandler);
         }
         _petExerciseListPanel.init(_info);
         _petExerciseListPanel.show();
      }
      
      private static function onOpenExeingPanelHandler(e:Event) : void
      {
         _petExerciseListPanel.sharedEvents.removeEventListener(Event.OPEN,onOpenExeingPanelHandler);
         _petExerciseListPanel.destroy();
         _petExerciseListPanel = null;
         if(Boolean(e))
         {
            showPetExercisePanel();
         }
      }
      
      private static function showPetExercisePanel() : void
      {
         if(!_petExercisePanel)
         {
            _petExercisePanel = new AppModel(ClientConfig.getAppModule("PetExercisePanel"),"正在进入");
            _petExercisePanel.setup();
            _petExercisePanel.sharedEvents.addEventListener(Event.OPEN,onOpenStartHandler);
            _petExercisePanel.sharedEvents.addEventListener(Event.CLOSE,onCloseStartHandler);
         }
         _petExercisePanel.init(PetManager.exePetListMap);
         _petExercisePanel.show();
      }
      
      private static function onCloseStartHandler(e:Event) : void
      {
         _petExercisePanel.sharedEvents.removeEventListener(Event.CLOSE,onCloseStartHandler);
         _petExercisePanel.sharedEvents.removeEventListener(Event.OPEN,onOpenStartHandler);
         _petExercisePanel.destroy();
         _petExercisePanel = null;
      }
      
      private static function onOpenStartHandler(e:Event) : void
      {
         onCloseStartHandler(null);
         if(Boolean(e))
         {
            showChoicePetImpersonationPanel();
         }
      }
      
      public static function destroy() : void
      {
         PetManager.removeEventListener(PetEvent.STORAGE_LIST,onListComHandler);
         if(Boolean(_choicePetImpersonationPanel))
         {
            onOpenCoursePanelHandler(null);
         }
         if(Boolean(_petExerciseListPanel))
         {
            onOpenExeingPanelHandler(null);
         }
         if(Boolean(_petExercisePanel))
         {
            onOpenStartHandler(null);
         }
      }
   }
}

