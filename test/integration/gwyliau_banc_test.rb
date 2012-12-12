# encoding: utf-8
require_relative '../integration_test_helper'

class GwyliauBancTest < ActionDispatch::IntegrationTest

  setup do
    artefact_data = artefact_for_slug('gwyliau-banc')
    artefact_data["details"].merge!(language: :cy)
    content_api_has_an_artefact('gwyliau-banc', artefact_data)   
  end

  should "display the Gwyliau Banc page" do

    visit "/gwyliau-banc"

    within 'head' do
      assert page.has_selector?("title", :text => "Gwyliau banc y DU - GOV.UK")
      desc = page.find("meta[name=description]")
      assert_equal "Calendr gwyliau banc y DU – edrychwch ar wyliau banc a gwyliau cyhoeddus y DU ar gyfer 2012 a 2013", desc["content"]

      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/gwyliau-banc.json']")
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/gwyliau-banc/cymru-a-lloegr.json']")
      assert page.has_selector?("link[rel=alternate][type='text/calendar'][href='/gwyliau-banc/cymru-a-lloegr.ics']")
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/gwyliau-banc/yr-alban.json']")
      assert page.has_selector?("link[rel=alternate][type='text/calendar'][href='/gwyliau-banc/yr-alban.ics']")
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/gwyliau-banc/gogledd-iwerddon.json']")
      assert page.has_selector?("link[rel=alternate][type='text/calendar'][href='/gwyliau-banc/gogledd-iwerddon.ics']")
    end

    within "#content" do
      within 'header' do
        assert page.has_content?("Gwyliau banc y DU")
        assert page.has_content?("Ateb cyflym")
      end

      within 'article' do
        within '.nav-tabs' do
          tab_labels = page.all("ul li a").map(&:text)
          assert_equal ['Cymru a Lloegr', 'Yr Alban', 'Gogledd Iwerddon'], tab_labels
        end

        within '.tab-content' do
          within '#cymru-a-lloegr' do
            assert page.has_table?("Gwyliau banc 2012 yng Nghymru a Lloegr", :headers => [
              "Dyddiad", "Diwrnod", "Enw'r Gwyliau","Nodiadau"], :rows => [
              ["02 Ionawr", "Dydd Llun", "Dydd Calan", "Diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos"],
              ["04 Mehefin", "Dydd Llun", "Gŵyl Banc y Gwanwyn", "Diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos"],
              ["05 Mehefin", "Dydd Mawrth", "Jiwbilî Diemwnt y Frenhines", "Gŵyl Banc ychwanegol"],
              ["27 Awst", "Dydd Llun", "Gŵyl Banc yr Haf", ""],
              ["25 Rhagfyr", "Dydd Mawrth", "Dydd Nadolig", ""],
              ["26 Rhagfyr", "Dydd Mercher", "Gŵyl San Steffan", ""]
            ])
            assert page.has_link?("Gwyliau banc 2012 yng Nghymru a Lloegr", :href => "/gwyliau-banc/cymru-a-lloegr-2012.ics")

            assert page.has_table?("Gwyliau banc 2013 yng Nghymru a Lloegr", :headers => [
              "Dyddiad", "Diwrnod", "Enw'r Gwyliau","Nodiadau"], :rows => [
              ["01 Ionawr", "Dydd Mawrth", "Dydd Calan", ""],
              ["29 Mawrth", "Dydd Gwener", "Dydd Gwener y Groglith", ""],
              ["25 Rhagfyr", "Dydd Mercher", "Dydd Nadolig", ""],
              ["26 Rhagfyr", "Dydd Iau", "Gŵyl San Steffan", ""],
            ])
            assert page.has_link?("Gwyliau banc 2013 yng Nghymru a Lloegr", :href => "/gwyliau-banc/cymru-a-lloegr-2013.ics")
          end

          within '#yr-alban' do
            assert page.has_table?("Gwyliau banc 2012 yn yr Alban", :headers => [
              "Dyddiad", "Diwrnod", "Enw'r Gwyliau","Nodiadau"], :rows => [
              ["02 Ionawr", "Dydd Llun", "2il Ionawr", ""],
              ["03 Ionawr", "Dydd Mawrth", "Dydd Calan", "Diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos"],
              ["04 Mehefin", "Dydd Llun", "Gŵyl Banc y Gwanwyn", "Diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos"],
              ["05 Mehefin", "Dydd Mawrth", "Jiwbilî Diemwnt y Frenhines", "Gŵyl Banc ychwanegol"],
              ["06 Awst", "Dydd Llun", "Gŵyl Banc yr Haf", ""],
              ["25 Rhagfyr", "Dydd Mawrth", "Dydd Nadolig", ""],
              ["26 Rhagfyr", "Dydd Mercher", "Gŵyl San Steffan", ""],
            ])
            assert page.has_link?("Gwyliau banc 2012 yn yr Alban", :href => "/gwyliau-banc/yr-alban-2012.ics")

            assert page.has_table?("Gwyliau banc 2013 yn yr Alban", :headers => [
              "Dyddiad", "Diwrnod", "Enw'r Gwyliau","Nodiadau"], :rows => [
              ["01 Ionawr", "Dydd Mawrth", "Dydd Calan", ""],
              ["29 Mawrth", "Dydd Gwener", "Dydd Gwener y Groglith", ""],
              ["02 Rhagfyr", "Dydd Llun", "Gŵyl Andreas", "Diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos"],
              ["25 Rhagfyr", "Dydd Mercher", "Dydd Nadolig", ""],
              ["26 Rhagfyr", "Dydd Iau", "Gŵyl San Steffan", ""],
            ])
            assert page.has_link?("Gwyliau banc 2013 yn yr Alban", :href => "/gwyliau-banc/yr-alban-2013.ics")
          end

          within '#gogledd-iwerddon' do
            assert page.has_table?("Gwyliau banc 2012 yng Ngogledd Iwerddon", :headers => [
              "Dyddiad", "Diwrnod", "Enw'r Gwyliau","Nodiadau"], :rows => [
              ["02 Ionawr", "Dydd Llun", "Dydd Calan", "Diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos"],
              ["19 Mawrth", "Dydd Llun", "Gŵyl San Padrig", "Diwrnod yn lle gŵyl banc sy'n disgyn ar benwythnos"],
              ["04 Mehefin", "Dydd Llun", "Gŵyl Banc y Gwanwyn", ""],
              ["05 Mehefin", "Dydd Mawrth", "Jiwbilî Diemwnt y Frenhines", "Gŵyl Banc ychwanegol"],
              ["27 Awst", "Dydd Llun", "Gŵyl Banc yr Haf", ""],
              ["25 Rhagfyr", "Dydd Mawrth", "Dydd Nadolig", ""],
              ["26 Rhagfyr", "Dydd Mercher", "Gŵyl San Steffan", ""],
            ])
            assert page.has_link?("Gwyliau banc 2012 yng Ngogledd Iwerddon", :href => "/gwyliau-banc/gogledd-iwerddon-2012.ics")

            assert page.has_table?("Gwyliau banc 2013 yng Ngogledd Iwerddon", :headers => [
              "Dyddiad", "Diwrnod", "Enw'r Gwyliau","Nodiadau"], :rows => [
              ["01 Ionawr", "Dydd Mawrth", "Dydd Calan", ""],
              ["29 Mawrth", "Dydd Gwener", "Dydd Gwener y Groglith", ""],
              ["12 Gorffennaf", "Dydd Gwener", "Brwydr y Boyne (Diwrnod yr Orangemen)", ""],
              ["25 Rhagfyr", "Dydd Mercher", "Dydd Nadolig", ""],
              ["26 Rhagfyr", "Dydd Iau", "Gŵyl San Steffan", ""],
            ])
            assert page.has_link?("Gwyliau banc 2013 yng Ngogledd Iwerddon", :href => "/gwyliau-banc/gogledd-iwerddon-2013.ics")
          end
        end # within .tab-content
      end # within article
    end # within #content
  end

  should "display the correct upcoming event" do
    Timecop.travel(Date.parse('2012-01-03')) do
      visit "/gwyliau-banc"

      within ".tab-content" do

        within '#cymru-a-lloegr .highlighted-event' do
          assert page.has_content?("Gŵyl Banc y Gwanwyn")
          assert page.has_content?("4 Mehefin")
        end

        within '#yr-alban .highlighted-event' do
          assert page.has_content?("Dydd Calan")
          assert page.has_content?("heddiw")
        end

        within '#gogledd-iwerddon .highlighted-event' do
          assert page.has_content?("Gŵyl San Padrig")
          assert page.has_content?("19 Mawrth")
        end
      end # within .tab-content
    end # Timecop
  end

  context "showing bunting on bank holidays" do
    should "show bunting when today is a buntable bank holiday" do
      Timecop.travel(Date.parse("2nd Jan 2012")) do
        visit "/gwyliau-banc"
        assert page.has_css?('.epic-bunting')
      end
    end

    should "not show bunting if today is a non-buntable bank holiday" do
      Timecop.travel(Date.parse("12th July 2013")) do
        visit "/gwyliau-banc"
        assert page.has_no_css?('.epic-bunting')
      end
    end

    should "not show bunting when today is not a bank holiday" do
      Timecop.travel(Date.parse("3rd Feb 2012")) do
        visit "/gwyliau-banc"
        assert page.has_no_css?('.epic-bunting')
      end
    end
  end

  context "last updated" do
    should "be translated and localised" do
      Timecop.travel(Date.parse("25th Dec 2012")) do
        visit "/gwyliau-banc"
        within ".meta-data" do
          assert page.has_content?("Diweddarwyd ddiwethaf: 25 Rhagfyr 2012")
        end
      end
    end
  end
end