"use client";
const linksArr = [
  {
    title: "About us",
    links: ["Our Company", "Careers", "Press kits"],
  },
  {
    title: "Legal",
    links: ["Terms of use", "Privacy policy", "About us"],
  },
  {
    title: "About us",
    links: ["Contact us", "FAQ"],
  },
];

const Footer = () => {
  return (
    <footer className="pb-14">
      <div className="max-w-[1440px] mx-auto w-[90%] flex flex-col gap-15 md:gap-10">
        <div className="w-auto h-auto md:w-52 md:h-20">
          {/* <Image
            src={raft_footer_logo}
            alt="raft_footer_logo"
            className="object-contain w-full h-full"
          /> */}
        </div>

        <div className="flex flex-col gap-8 pt-15 border-t border-gray-800 dark:border-gray-200">
          <div className="flex justify-between gap-8 md:flex-col">
            {/* QR Section */}
            <div className="flex gap-3.5 p-5 border border-dashed border-black dark:border-white rounded-lg">
              <div>{/* <Image src={qr_code} alt="qr_code" /> */}</div>
              <div className="flex flex-col gap-4">
                <p className="max-w-xs text-lg font-normal">
                  Scan to download App on the Playstore and Appstore.
                </p>
                <div className="flex items-center gap-3">
                  {/* <Image src={ic_google_playstore} alt="playstore icon" /> */}
                  {/* <Image src={ic_baseline_apple} alt="apple icon" /> */}
                </div>
              </div>
            </div>

            {/* Navigation Links */}
            <div className="grid grid-cols-3 md:grid-cols-2 gap-12 md:gap-x-15 md:gap-y-10">
              {linksArr.map((section, index) => (
                <div key={index} className="flex flex-col gap-4">
                  <h3 className="text-lg font-medium">{section.title}</h3>
                  <ul className="flex flex-col gap-3">
                    {section.links.map((link, i) => (
                      <li
                        key={i}
                        className="font-normal relative hover:after:scale-x-100 after:content-[''] after:absolute after:w-full after:h-[1px] after:left-0 after:bottom-[-5px] after:scale-x-0 after:origin-center after:transition-transform after:duration-500 text-black dark:text-white after:bg-black dark:after:bg-white"
                      >
                        {link}
                      </li>
                    ))}
                  </ul>
                </div>
              ))}
            </div>
          </div>

          {/* Footer Bottom Section */}
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-4 cursor-pointer">
              <h3 className="text-xl font-normal md:text-sm">
                English (United Kingdom)
              </h3>
              {/* <Image src={ic_chevron_down} alt="chevron down" /> */}
            </div>
            <div className="flex items-center gap-2 md:text-sm">
              {/* <Image src={ic_copyright} alt="copyright svg" /> */}
              <span>Raft Corp, LLC.</span>
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
