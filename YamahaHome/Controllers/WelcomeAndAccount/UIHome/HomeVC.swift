//
//  HomeVC.swift
//  CreateUI
//
//  Created by ThuNQ on 10/13/20.
//  Copyright © 2020 ThuNQ. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeVC: UIViewController {
    
    @IBOutlet weak var collectionViewProduct: BaseCollectionView!
    @IBOutlet weak var collectionViewHighlight: BaseCollectionView!
    @IBOutlet weak var tableViewEvent: BaseTableView!
    @IBOutlet weak var heightProduct: NSLayoutConstraint!
    @IBOutlet weak var heightHeighlight: NSLayoutConstraint!
    @IBOutlet weak var heightEvent: NSLayoutConstraint!
    
    @IBOutlet weak var naviBar: CustomNaviBar!
    {
        didSet{
            naviBar.viewContent.backgroundColor = .white
            naviBar.buttonBack.isHidden = true
            naviBar.imageCenterView.isHidden = false
            naviBar.rightButtonFirst.isHidden = false
            naviBar.rightButtonFirst.iconImage = UIImage("icon_user")
            
        }
    }
    
    var removeView: (() -> Void)?
    
    var dataSourcProduct = CollectionDataSource<ProductModel,ProductCell>()
    var dataSourcHighlight = CollectionDataSource<HighlightModel,HighlightCell>()
    var dataSourcNewsEvent = TableDataSource<NewsEventModel,NewsEventCell>()
    
    var listProduct: [ProductModel] = [ProductModel(title: "Pianos", image: "product_1", content: """
ENSPIRE PRO
                                                    Fully integrated high-resolution record and playback system
                                                    Recording Formats: XP MIDI, Standard MIDI, Audio WAV, Audio Sync, Video Sync
                                                    Supported File Formats: XP and Standard MIDI, MP3, WAV
                                                    500 built-in songs
                                                    Available Songs: 9,000
                                                    Streaming radio service with 30+ channels
                                                    Streaming video service (free with radio subscription)
                                                    1024 levels of keying velocity
                                                    1024 levels of key release velocity
                                                    256 levels of incremental pedaling
                                                    Damper and shift pedal movement reproduction
                                                    Non-Contact Optical Sensor System
                                                    Key Sensor type: Continuous grayscale
                                                    Hammer Sensor type: Continuous grayscale
                                                    Damper and Shift Pedal Sensor type: Continuous grayscale
                                                    Sostenuto Sensor type: On/Off detection system
                                                    Drive System Sensor type: Magnetic solenoid sensor
                                                    DSP servo feedback system: AccuPlay (key, hammer, pedal and key drive system)
                                                    Auto-calibration and real-time auto-adjusting playback
                                                    Quiet Mode and SILENT Mode with motorized muting system
                                                    16 playable digital voices (binaural CFX Concert Grand for headphones)
                                                    480 ensemble voices with 12 Drum Kits
                                                    256-note polyphony
                                                    Compatible storage media: USB Flash Memory (up to 128GB)
                                                    MIDI connectivity: 5-pin MIDI IN/OUT, USB TO HOST
                                                    Audio connectivity: Analog audio IN x 2, analog audio OUT x 4, digital coax OUT (2CH)
                                                    Headphone connectivity: 1/8” mini stereo
                                                    Data connectivity: LAN, USB TO DEVICE x 3
                                                    Integrated speakers: Yamaha MSP3 powered monitors x 2
                                                    Control integration: iOS/Android app, Mac/PC browser, MusicCast app, custom API
                                                    Available models: C3X, C5X, C6X, C7X, S3X, S5X, S6X, S7X, CF4, CF6, CFX
"""),
                                       ProductModel(title: "Keyboard Instruments", image: "product_2", content: """
Genos V2.0 – A New Chapter Begins
When Genos entered the market, it set new benchmark for Digital Workstations and was quickly adopted by enthusiastic players, stage performers and studio musicians across the world. It was the suggestions and feedback from these customers that lead to the introduction of Version 1.4 Now we are excited to introduce the next chapter: Genos Version 2.0. With this exciting new upgrade, the best gets even better with new features such as Chord Looper and Style Section Reset - in addition to increasing available expansion memory from 1.8GB to 3.0GB! But that’s not all, Genos Version 2.0 introduces the Superior Pack containing stunning new musical content with 50 brand new Styles and more than 68 Voices, including all new Super Articulation 2 sounds. We would like to thank the Genos community for their continued support and invite all keyboard enthusiasts to explore new dimension of music with Genos Version 2.0
"""),
                                       ProductModel(title: "Guitars, Basses & Amps", image: "product_3", content: """
Yamaha and Billy Sheehan Celebrate 30th Anniversary of Attitude Series
In appreciation of this milestone, Yamaha is releasing the Attitude 30th. Limited to thirty pieces in recognition of thirty years of Attitude, this anniversary model pays tribute to The Wife, Billy’s heavily customized original bass which laid the groundwork for the Attitude series and the decades of trailblazing music it inspired.

The Wife’s nickname comes from a period in Sheehan’s early career in which he and the bass were effectively inseparable. “Thousands of shows were played on that bass, so it became a real part of me,” he explains. “It was with me constantly. People would knock on my door, and I’d open the door with the thing on, and they’d say ‘Don’t you ever put that thing down?’” His response: “No, I don’t, actually – I’m always playing it!’”

While Billy is most closely associated with the Attitude series, his history with Yamaha goes back even further. “There was a company in Buffalo that sold pro audio gear,” he recalls, “but they also had a Yamaha BB bass, and it was gorgeous. It was perfect. Quality control on it was spectacular. That stayed with me, the quality of these Yamaha instruments. In 1984, Yamaha contacted me and said, ‘We’d be interested in making a bass for you’.”
"""),
                                       ProductModel(title: "Drums", image: "product_4", content: """
At Yamaha, each drum's evolution begins with a prototype. Under a completely new concept, the PHX (pronounced "phoenix") series is the pinnacle of excellence in this prototyping process. Handcrafted by our expert technicians, it is rooted in over 50 years of history, tradition, experience and technology in an all-out pursuit of the ultimate in drum craftsmanship and sound.
PHX
We re-defined the high-end drum set when we introduced the Recording Custom in the 1970s. With the PHX, we set the bar even higher by creating the ultimate musical instrument for drummers.
"""),
                                       ProductModel(title: "Brass & Woodwinds", image: "product_5", content: """
Professional Flutes
Inheriting the many merits of top-of-the-line Yamaha handmade flutes, these models offer rich, nuanced tonality over a wide dynamic range. The 500 and 600 series combine the brillance of nickel silver with the characteristic mellow timbres of sterling silver, while the 700 series delivers warmth and expressive color that only the finest silver flutes can provide. All models come with hand-finished headjoints based on the Type A headjoints supplied with the 800 and 900 series handmade flutes. The keys feature traditional pointed key arms, reflecting the highest level of craftsmanship and adding visual elegance to these outstanding instruments.
"""),
                                       ProductModel(title: "Strings", image: "product_6", content: """
YSV104
The YSV104 Silent Violin returns to the original Silent Violin concept as a refined practice instrument that provides an ideal blend of features and playability for violin players.
Even without a resonant body, the SRT POWERED system faithfully reproduces the body resonance, sound and ambience of an acoustic violin. The YSV104 is an excellent choice for all players who want to practice quietly with acoustic violin tone.
"""),
                                       ProductModel(title: "Percussion", image: "product_7", content: """
MS-9300 SFZ™ Series 14” x 12” Sforzando Marching Snare Drum
The MS-9300 Series has been created on the basis of experience and an enviable track record at some of the world’s top fields. New features include maple shells and a design that allows high-tension tuning.
"""),
                                       ProductModel(title: "Marching Instrucments", image: "product_8", content: """
MQ-8300 Field-Corps™ Series 8300 Field-Corps Series Multi-Toms
Yamaha's Field-Corps multi-toms deliver a pure, focused tone that is maximized by a deeper, more balanced set of multi-toms. These toms are equipped with a lug that utilizes an arch-shape design which allows the shell to vibrate freely thus delivering greater tone. The Field-Corps multi-toms are also equipped with a 2.3mm thick, steel Ultra Hoop™ rim that is specially designed by Yamaha. Its profile protects the bearing edge from mallet sweeps, which is especially important as the rim height lowers.
""")]
    var listHighlight: [HighlightModel] = [HighlightModel(title: "Stay True", image: "highlight_1", content: """
MQ-8300 Field-Corps™ Series 8300 Field-Corps Series Multi-Toms
Yamaha's Field-Corps multi-toms deliver a pure, focused tone that is maximized by a deeper, more balanced set of multi-toms. These toms are equipped with a lug that utilizes an arch-shape design which allows the shell to vibrate freely thus delivering greater tone. The Field-Corps multi-toms are also equipped with a 2.3mm thick, steel Ultra Hoop™ rim that is specially designed by Yamaha. Its profile protects the bearing edge from mallet sweeps, which is especially important as the rim height lowers.

The multi-toms also utilize a high-strength aluminum reinforcement ring inserted just below the bearing edge to maintain shell integrity—especially when high-tension tuning is used.
"""),
                                           HighlightModel(title: "New Genos Digital\nWorkstation", image: "highlight_2", content: """
Incredible Sounds, Effects, and Styles Make Yamaha Genos the Ultimate Songwriting and Performance Keyboard
BUENA PARK, Calif. (October 2, 2017) — Yamaha today announced Genos, the most advanced Digital Workstation keyboard ever imagined. Packed with incredible sounds, enhanced DSP effects, stunningly real accompaniment Styles, and studio integration, Genos represents the new benchmark in sound, playing experience and visual appeal.
Genos is a whole new type of flagship instrument, rethought from the ground up to inspire and empower songwriters to create finished compositions entirely within its intuitive and powerful environment — while at the same time vastly improving the accompaniment features that live keyboard entertainers know and love.
Featuring a sleek and modern design that commands attention onstage, this game-changing instrument is set to elevate performance and enjoyment for professional musicians, hobbyists, and listeners alike.
"""),
                                           HighlightModel(title: "TF Series Digital Mixing\nConsole", image: "highlight_3", content: """
TF Series
Yamaha has always made it a mission to stay in touch with the needs of sound engineers worldwide. The outcome is evident in the success of the recent CL and QL series digital mixing consoles, and the flagship RIVAGE PM10. The key to success has always been in supporting the user’s creativity. Creativity is most effective when unrestricted, and now Yamaha has created a new digital mixing console that gives the user's intuition even freer rein. TouchFlow Operation™ introduced in the TF series consoles allows the user to respond to the music and artists on stage with unprecedented speed and freedom, taking live sound reinforcement to a new level of refinement. With the TouchFlow Operation interface optimized for touch panel control, experienced engineers as well as newcomers to the field will find it easier than ever to achieve the ideal mix. Recallable D-PRE™ preamplifiers support sound quality that will satisfy the most discerning professional ears, while advanced live recording features and seamless operation with high-performance I/O racks give these compact digital mixers capabilities that make them outstanding choices for a wide range of applications. Experience the intuitive control and creative freedom that a truly
"""),
                                           HighlightModel(title: "Emerging Artists", image: "highlight_4", content: """
WAY UP’s emerging artists come together in different places around the world to talk about their experiences in the music industry, what it means to express themselves through their songs and how they progress personally with their music.
"""),
                                           HighlightModel(title: "New DTX402 Series", image: "highlight_5", content: """
DTX402 Series
Take the first step towards

finding your inspiration and thrive.

Don’t let your creativity remain hidden.

Take control of your destiny and find your purpose.

Find your passion and shape your future with DTX402.
"""),
                                           HighlightModel(title: "New HW3 Advanced Lightweight Hardware Set", image: "highlight_6", content: """
HW-3 CROSSTOWN - Advanced Lightweight Hardware
CROSSTOWN - Advanced Lightweight Hardware

This advanced lightweight hardware set is the result of research and development conducted with artists and designers who determined just how light a hardware stand can be without sacrificing the durability and strength drummers have come to expect from Yamaha hardware.
""")]
    var listEvents: [NewsEventModel] = [NewsEventModel(title: "Ten U.S. Schools Named 'Yamaha Institutions of Excellence'", subTitle: "Yamaha has named 10 distinguished colleges and universities to its inaugural Yamaha Institution of Excellence program, recognizing extraordinary commitment to innovation in the study of music.", image: "highlight_6", startDate: "22/03/2021", content: """
Ten U.S. Schools Named 'Yamaha Institutions of Excellence'
BUENA PARK, Calif. (February 22, 2021) — Yamaha has named 10 distinguished colleges and universities to its inaugural Yamaha Institution of Excellence program, recognizing extraordinary commitment to innovation in the study of music.
This year's recipients, chosen from outstanding schools across the country, are:
Auburn University
Berklee College of Music
Eastman School of Music, University of Rochester
Southeast Missouri State University - Holland College of Arts and Media
SUNY Potsdam’s Crane School of Music
The New School - The College of Performing Arts
University of Alabama in Huntsville
University of Kentucky School of Music
"""),
                                        NewsEventModel(title: "Yamaha DGX-670 Digital Piano Brings Modern Aesthetic, Color Display and Simplified User Interface to Hugely Popular Series", subTitle: "Yamaha today unveiled the DGX-670, a stylish digital piano featuring a modern, attractive aesthetic and a simplified user interface.", image: "highlight_6", startDate: "25/03/2021", content: """
Yamaha DGX-670 Digital Piano Brings Modern Aesthetic, Color Display and Simplified User Interface to Hugely Popular Series

The new "Portable Grand" ensemble instrument is a full, 88-note weighted action keyboard with exceptional playability, superb sound and visual appeal, making it ideal for beginners and accomplished pianists alike. It replaces the DGX-660, which has earned accolades as one of the top-selling digital pianos in the world.
The DGX-670 includes the company's Graded Hammer Standard keyboard action—the low keys have a heavier response and the high keys have a lighter response—which delivers the touch piano teachers recommend for building proper finger technique for playing acoustic pianos.
Yamaha is known for its outstanding acoustic pianos, and the DGX-670 offers precise samples of the company's flagship 9-foot concert grand piano, the CFX, which is sonically characterized by an exquisite tone across the entire dynamic range.
While the DGX-660 had a traditional, rectangular frame, the DGX-670 has been totally redesigned with a modern body featuring curved edges. Operation of a wide selection of functions is made quick and easy, thanks to a new, full-color LCD screen featuring a simplified user interface. The keyboard also has enlarged buttons on the front panel that feel nice to the touch without taking up too much space.

""")]
    
    var ref: DatabaseReference!
    let popup = PopupConnectVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        initViewProduct()
        initViewHighlight()
        initViewNewsEvent()
        checkFirebase()
        naviBar.rightButtonFirst.didTap = {
            //            let defaults = UserDefaults.standard
            //            defaults.set([], forKey: "data_tiktok")
            //            defaults.set(false, forKey: "login_check")
            //            defaults.synchronize()
            let vc = ProfileVC()
            self.push(vc)
        }
        naviBar.buttonBack.didTap = {
            self.pop()
        }
    }
    
    func checkFirebase(){
        ref = Database.database().reference()
        self.ref.child("status").observeSingleEvent(of: .value, with: { (snapshot) in
            if let status = snapshot.value as? Bool {
                if status{
                    let checkLogin = UserDefaults.standard.bool(forKey: "login_check")
                    if !checkLogin{
                        self.showPopup()
                    }
                }
            }
        })
    }
    
    
    private func setupCollectionView(){
        collectionViewProduct.registerNibCellFor(type: ProductCell.self)
        collectionViewHighlight.registerNibCellFor(type: HighlightCell.self)
        tableViewEvent.registerNibCellFor(type: NewsEventCell.self)
    }
    
    private func showPopup(){
        popup.willMove(toParent: self)
        self.addChild(popup)
        self.view.addSubview(popup.view)
        popup.didMove(toParent: self)
        popup.connectFB = {
            print("connect")
            let vc = FBLoginVC()
            self.push(vc)
        }
        popup.closeAction = {
            print("close")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.showPopup()
            }
        }
    }
}

extension HomeVC {
    private func initViewProduct(){
        collectionViewProduct.didChangeContentSize = { [weak self] contentSize in
            self?.heightProduct.constant = contentSize.height + 10
        }
        collectionViewProduct.setup(dataSourcProduct, cells: ProductCell.self)
        let widthItem = (SystemInfo.screenWidth) / 2
        dataSourcProduct.sizeColumn = CGSize(width: widthItem, height: widthItem)
        dataSourcProduct.minimumLineSpacing = 16
        dataSourcProduct.bindingCell = { cell, data, row in
            cell.configCell(data: data)
        }
        dataSourcProduct.didSelectRowAt = { [weak self] data, row in
            let vc = AdsDetailVC()
            vc.product = data
            vc.index = 0
            self?.push(vc)
        }
        dataSourcProduct.setupData(listProduct)
    }
    
    private func initViewHighlight(){
        collectionViewHighlight.didChangeContentSize = { [weak self] contentSize in
            self?.heightHeighlight.constant = contentSize.height + 10
        }
        collectionViewHighlight.setup(dataSourcHighlight, cells: HighlightCell.self)
        let widthItem = (SystemInfo.screenWidth) / 2
        dataSourcHighlight.sizeColumn = CGSize(width: widthItem, height: widthItem)
        dataSourcHighlight.minimumLineSpacing = 16
        dataSourcHighlight.bindingCell = { cell, data, row in
            cell.configCell(data: data)
        }
        dataSourcHighlight.didSelectRowAt = { [weak self] data, row in
            let vc = AdsDetailVC()
            vc.highlightModel = data
            vc.index = 1
            self?.push(vc)
        }
        dataSourcHighlight.setupData(listHighlight)
    }
    
    private func initViewNewsEvent(){
        tableViewEvent.didChangeContentSize = { [weak self] contentSize in
            self?.heightEvent.constant = contentSize.height + 10
        }
        dataSourcNewsEvent.bindingCell = { cell,data, row in
            cell.selectionStyle = .none
            cell.configCell(data: data)
        }
        dataSourcNewsEvent.didSelectRowAt = { [weak self] data,row in
            let vc = AdsDetailVC()
            vc.newsEventModel = data
            vc.index = 2
            self?.push(vc)
        }
        tableViewEvent.setup(source: dataSourcNewsEvent, registerNibCells: [NewsEventCell.self])
        dataSourcNewsEvent.setupData(listEvents)
    }
}
