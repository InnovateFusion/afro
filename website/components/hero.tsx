"use client";
import Image from "next/image";
import { motion } from "framer-motion";
import { AnimatedGradientTextDemo } from "./animatedText";
import MaskText from "./MaskText";

export const Hero = () => {
  return (
    <div className="bg-light-bg text-light-text dark:bg-dark-bg dark:text-dark-text bg-[linear-gradient(to_bottom,var(--bg-gradient-start),var(--bg-gradient-mid1)_34%,var(--bg-gradient-mid2)_65%,var(--bg-gradient-end)_82%)] py-40 sm:py-24 relative overflow-clip">
      <div className="absolute h-[375px] w-[750px] sm:w-[1536px] sm:h-[768px] lg:w-[2400px] llg:h-[800px] rounded-[100%] bg-light-bg dark:bg-dark-bg left-1/2 -translate-x-1/2  border-[#B48CDE] bg-[radial-gradient(closest-side,var(--radial-gradient-start)_82%,var(--radial-gradient-end))] top-[calc(100%-96px)] sm:top-[calc(100%-120px)]"></div>

      <div className="container relative mx-auto">
        <div className="flex items-center justify-center -mt-10">
          <AnimatedGradientTextDemo />
        </div>
        <div className="flex justify-center mt-8 ">
          <div className="inline-flex relative">
            <h1 className="text-7xl sm:text-9xl font-bold tracking-tightner text-center inline-flex">
              Afro <br /> Fashion
            </h1>
            <motion.div
              className="absolute right-[36px] -top-[50px] hidden sm:inline dark:invert cursor-pointer"
              initial={{ scale: 0.7 }}
              whileHover={{ scale: 0.75, right: 32 }}
            >
              <Image
                src={"/1541754237.png"}
                alt="afro"
                height={200}
                width={200}
                className="max-w-none"
                draggable="false"
              />
            </motion.div>
            <motion.div
              className="absolute right-[648px] top-[158px] hidden sm:inline cursor-pointer"
              drag
              dragConstraints={{
                left: -100,
                right: 100,
                top: -100,
                bottom: 100,
              }}
              whileDrag={{ scale: 1.2 }}

              // dragSnapToOrigin
            >
              <Image
                src={"/clothes/25.png"}
                alt="cursor"
                height={200}
                width={200}
                className="max-w-none"
                draggable="false"
              />
            </motion.div>
            <motion.div
              className="absolute left-[578px] -top-[26px] hidden sm:inline cursor-pointer"
              drag
              dragConstraints={{
                left: -100,
                right: 100,
                top: -100,
                bottom: 100,
              }}
              whileDrag={{ scale: 1.2 }}
              dragSnapToOrigin
            >
              <Image
                src={"/clothes/5.png"}
                alt="cursor"
                height={200}
                width={200}
                className="max-w-none"
                draggable="false"
              />
            </motion.div>
          </div>
        </div>
        <div className="flex justify-center">
          {/* <p className="text-xl text-center mt-8 max-w-md">
            Choosing what you wear should be easy, fun and cozy.
          </p> */}
          <MaskText
            phrases={["Choosing what you wear should be easy, fun and cozy."]}
            tag="h1"
            className="text-xl text-center mt-8 max-w-md"
          />
        </div>
        <div className="flex justify-center mt-8">
          <motion.a
            whileHover={{ scale: 1.1 }}
            className="dark:bg-white dark:text-black text-white bg-black py-3 px-5 rounded-lg font-medium"
            href="#waitlist"
          >
            24 Get your choice
          </motion.a>
        </div>
      </div>
    </div>
  );
};
