-- 针对 core/exppattern.lua 的一些测试用例

TestExppattern = {}

function TestExppattern:testMatchExp()
  local exp1 = Exppattern:Parse("slash,jink")
  lu.assertTrue(exp1:matchExp("peack,jink"))
end

function TestExppattern:testEasyMatchCard()
  local exp1 = Exppattern:Parse("slash,jink")
  local exp2 = Exppattern:Parse("peach,jink")
  local slash = Fk:cloneCard("slash")
  lu.assertTrue(exp1:match(slash))
  lu.assertFalse(exp2:match(slash))
end

function TestExppattern:testAdvanceMatchCard()
  local exp1 = Exppattern:Parse("slash,jink")
  local exp2 = Exppattern:Parse(".|.|.|.|peach,slash")
  local slash = Fk:cloneCard("slash")
  lu.assertTrue(exp1:match(slash))
  lu.assertTrue(exp2:match(slash))
  local t_slash = Fk:cloneCard("thunder__slash")
  lu.assertTrue(exp1:match(t_slash))
  lu.assertFalse(exp2:match(t_slash))

  lu.assertTrue(exp1:matchExp(exp2))
  lu.assertTrue(exp2:matchExp(exp1))
  local exp3 = Exppattern:Parse(".|.|.|.|thunder__slash")
  lu.assertTrue(exp1:matchExp(exp3))
  lu.assertFalse(exp3:matchExp(exp2))
  lu.assertTrue(exp3:matchExp(exp1))
end

function TestExppattern:testMatchWithType()
  local exp3 = Exppattern:Parse(".|.|.|.|.|normal_trick")
  lu.assertFalse(exp3:matchExp("slash,jink"))
  lu.assertTrue(exp3:matchExp("peach,ex_nihilo"))

  local basic = Exppattern:Parse(".|.|.|.|.|basic")
  lu.assertFalse(basic:matchExp("nullification"))
  lu.assertTrue(basic:matchExp("slash,vine"))
  lu.assertTrue(Exppattern:Parse(".|.|.|.|.|armor"):matchExp("slash,vine"))
  lu.assertTrue(Exppattern:Parse(".|.|.|.|.|trick"):matchExp("lightning"))
  lu.assertFalse(Exppattern:Parse(".|.|.|.|.|delayed_trick"):matchExp("savage_assault"))
end

function TestExppattern:testMatchNeg()
  lu.assertError(function() Exppattern:Parse("^(a,|1)") end)
  local not_nul = Exppattern:Parse("^nullification")
  local not_slash_jink = Exppattern:Parse("^(slash,jink)")
  local not_basic = Exppattern:Parse(".|.|.|.|.|^basic")
  local not_black = Exppattern:Parse(".|.|^(spade,club)")
  local slash_jink = Exppattern:Parse("slash,jink")
  local no_slash_jink = Exppattern:Parse("^(slash,jink)|.|.|.|.|basic")
  local slash = Fk:cloneCard("slash")

  lu.assertFalse(not_nul:matchExp("nullification"))
  lu.assertTrue(not_basic:matchExp("nullification"))
  lu.assertFalse(not_slash_jink:matchExp("jink"))
  lu.assertTrue(not_nul:match(slash))
  lu.assertFalse(not_slash_jink:match(slash))
  lu.assertFalse(not_basic:match(slash))
  lu.assertTrue(not_nul:matchExp("peach"))
  lu.assertFalse(not_basic:matchExp(no_slash_jink))
  lu.assertTrue(not_slash_jink:matchExp(not_basic))
  lu.assertFalse(slash_jink:matchExp(not_slash_jink))
  lu.assertFalse(not_black:matchExp("slash|A~Q|spade"))
  lu.assertTrue(not_black:matchExp("vine|10|^club"))
end
