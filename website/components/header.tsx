// import LogoImage from "../assets/icons/logo.svg";
// import MenuIcon from "../assets/icons/menu.svg";

import Image from "next/image";
import Link from "next/link";

export const Navbar = () => {
  return (
    <div className="container mx-auto">
      <div className="px-4">
        <div className="container ">
          <div className="py-4 flex items-center justify-between">
            <div className="relative hidden md:block">
              <Image
                src="/clothes/15.png"
                alt="AfroStyle"
                width={50}
                height={50}
              />
            </div>
            {/* <div className="border border-black dark:border-white border-opacity-30 h-10 w-10 inline-flex justify-center items-center rounded-lg sm:hidden">
              <MenuIcon className="text-black dark:text-white" />
            </div> */}
            <nav className="text-black dark:text-white gap-6 items-center hidden sm:flex">
              {/* <a
                href="#"
                className="text-opacity-60 text-black dark:text-white hover:text-opacity-100 transition"
              >
                About
              </a>
              <a
                href="#"
                className="text-opacity-60 text-black dark:text-white hover:text-opacity-100 transition"
              >
                Features
              </a>
              <a
                href="#"
                className="text-opacity-60 text-black dark:text-white hover:text-opacity-100 transition"
              >
                Updates
              </a>
              <a
                href="#"
                className="text-opacity-60 text-black dark:text-white hover:text-opacity-100 transition"
              >
                Help
              </a>
              <a
                href="#"
                className="text-opacity-60 text-black dark:text-white hover:text-opacity-100 transition"
              >
                Customers
              </a> */}
              <Link
                className="bg-black dark:bg-white py-2 px-4 rounded-lg text-white dark:text-black"
                href="#waitlist"
              >
                Open your Shop
              </Link>
            </nav>
          </div>
        </div>
      </div>
    </div>
  );
};
