package WordAssault;


import java.util.*;
public class WordBank
{
    private ArrayList<String> bank;      //NEVER ADD PAUSE AS A WORD!!!!!
    public WordBank()
    {
        bank = new ArrayList<>();
        bank.add("fail");
        bank.add("random");
        bank.add("dog");
        bank.add("cat");
        bank.add("cry");
        bank.add("pie");
        bank.add("elephant");
        bank.add("bear");
        bank.add("eat");
        bank.add("air");
        bank.add("pear");
        bank.add("apple");
        bank.add("pineapple");
        bank.add("pen");
        bank.add("carrot");
        bank.add("movie");
        bank.add("theater");
        bank.add("schmeckle");
        bank.add("meeseeks");
        bank.add("squanching");
        bank.add("oxytocin");
        bank.add("headlock");
        bank.add("top");
        bank.add("fright");
        bank.add("call");
        bank.add("going");
        bank.add("position");
        bank.add("heretical");
        bank.add("dismemberment");
        bank.add("loneliness");
        bank.add("blindfold");
        bank.add("expose");
        bank.add("federation");
        bank.add("connect");
        bank.add("dolphin");
        bank.add("identity");
        bank.add("triangle");
        bank.add("hook");
        bank.add("dream");
        bank.add("martini");
        bank.add("soft");
        bank.add("hideaway");
        bank.add("brigade");
        bank.add("antelope");
        bank.add("allergy");
        bank.add("rib");
        bank.add("acid");
        bank.add("parasite");
        bank.add("scenic");
        bank.add("anxiety");
        bank.add("communicate");
        bank.add("bar");
        bank.add("bark");
        bank.add("burden");
        bank.add("enigma");
        bank.add("drift");
        bank.add("corrosive");
        bank.add("solitary");
        bank.add("gender");
        bank.add("doll");
        bank.add("play");
        bank.add("aerodynamic");
        bank.add("prong");
        bank.add("intruder");
        bank.add("captive");
        bank.add("pinch");
        bank.add("rubber");
        bank.add("logic");
        bank.add("raven");
        bank.add("healthy");
        bank.add("near");
        bank.add("servant");
        bank.add("desperate");
        bank.add("meme");
        bank.add("friend");
        bank.add("birthday");
        bank.add("contagious");
        bank.add("glacier");
        bank.add("bludgeon");
        bank.add("felon");
        bank.add("computer");
        bank.add("seniors");
        bank.add("graduation");
        bank.add("armageddon");
        bank.add("rapture");
        bank.add("concatenate");
        bank.add("exasperated"); 
        bank.add("physiology");
        bank.add("clock");
        bank.add("doomsday");
        bank.add("quarantine");
        bank.add("paparazzi");
        bank.add("ooze");
        bank.add("flip");
        bank.add("keyboard");
        bank.add("teleport");
        bank.add("miniverse");
        bank.add("multiverse");
        bank.add("blood");
        bank.add("shirt");
        bank.add("reject");
        bank.add("meme");
        bank.add("samsung");
        bank.add("monitor");
        bank.add("millennial");
        bank.add("sentry");
        bank.add("century");
        bank.add("tadpole");
        bank.add("digglet");
        bank.add("squat");
        bank.add("squash");
        bank.add("religion");
        bank.add("amendment");
        bank.add("retail");
        bank.add("ripoff");
        bank.add("tapestry");
        bank.add("squint");
        bank.add("tantrum");
        bank.add("tangent");
        bank.add("arachnid");
        bank.add("chatter");
        bank.add("fidget");
        bank.add("spinner");
        bank.add("top");
        bank.add("bottom");
        bank.add("light");
        bank.add("dark");
        bank.add("equality");
        bank.add("tyranny");
        bank.add("spot");
        bank.add("waldo");
        bank.add("find");
        bank.add("dalmatian");
        bank.add("potential");
        bank.add("calculus");
        bank.add("trauma");
        bank.add("flinch");
        bank.add("asterisk");
        bank.add("document");
        bank.add("tabular");
        bank.add("derivative");
        bank.add("origins");
        bank.add("empire");
        bank.add("spite");
        bank.add("fiend");
        bank.add("deceased");
        bank.add("ashes");
        bank.add("crematorium");
        bank.add("brave");
        bank.add("new");
        bank.add("world");
        bank.add("curvy");
        bank.add("thick");
        bank.add("swine");
        bank.add("flu");
        bank.add("pigeon");
        bank.add("tarantula");
        bank.add("hashbrown");
        bank.add("onion");
        bank.add("son");
        bank.add("bun");
        bank.add("emergency");
        bank.add("room");
        bank.add("disappear");
        bank.add("warrant");
        bank.add("felony");
        bank.add("ticket");
        bank.add("bill");
        bank.add("incarceration");
        bank.add("grave");
        bank.add("iris");
        bank.add("speed");
        bank.add("fast");
        bank.add("scarlet");
        bank.add("zoom");
        bank.add("reverse");
        bank.add("flash");
        bank.add("vibe");
        bank.add("frost");
        bank.add("murder");
        bank.add("gestation");
        bank.add("lactate");
        bank.add("uncanny");
        bank.add("point");
        bank.add("shove");
        bank.add("ram");
        bank.add("card");
        bank.add("cast");
        bank.add("crew");
        bank.add("dementia");
        bank.add("amnesia");
        bank.add("tab");
        bank.add("cram");
        bank.add("procrastinate");
        bank.add("sleep");
        bank.add("management");
        bank.add("street");
        bank.add("hood");
        bank.add("cul de sac");
        bank.add("bitter");
        bank.add("sore");
        bank.add("pathetic");
        bank.add("attraction");
        bank.add("magnet");
        bank.add("iron");
        bank.add("copper");
    }
    
    public String choseWord()
    {
        int index = (int)(Math.random()*bank.size());
        return bank.get(index);
    }
}