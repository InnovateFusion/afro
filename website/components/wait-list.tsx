// Start of Selection
"use client";
import Image from "next/image";
import { motion, useScroll, useTransform } from "framer-motion";
import { useRef } from "react";
import MaskText from "./MaskText";

export const CallToAction = () => {
  const containerRef = useRef<HTMLDivElement>(null);

  const { scrollYProgress } = useScroll({
    target: containerRef,
    offset: ["start end", "end end"],
  });

  const translateY = useTransform(scrollYProgress, [0, 1], [100, 0]);

  return (
    <div
      className=" flex flex-col items-center text-black dark:text-white py-[72px] sm:py-24 px-5"
      ref={containerRef}
      id="waitlist"
    >
      <div className="container max-w-xl relative">
        <motion.div style={{ translateY }}>
          <Image
            src={"/clothes/25.png"}
            alt="helix"
            width={200}
            height={200}
            className="absolute top-6 left-[calc(100%+36px)]"
          />
        </motion.div>
        <motion.div style={{ translateY }}>
          <Image
            src={"/clothes/8.png"}
            alt="emoji"
            width={200}
            height={200}
            className="absolute -top-[120px] right-[calc(100%+30px)]"
          />
        </motion.div>

        <MaskText
          className="font-bold text-5xl sm:text-6xl tracking-tighter text-center"
          phrases={["Join the waitlist"]}
          direction="up"
          tag="h2"
        />
        <MaskText
          className="text-xl text-black/70 dark:text-white/70 mt-5 text-center"
          phrases={[
            "Join our waitlist to be among the first to experience Afro Fashion's innovative marketplace. Get early access to exclusive African-inspired fashion, connect with authentic vendors, and be part of our growing community.",
          ]}
          direction="up"
          tag="p"
        />
        <form
          className="mt-10 flex flex-col gap-2.5 max-w-sm mx-auto sm:flex-row"
          action="https://formbold.com/s/67PaA"
          method="POST"
          encType="multipart/form-data"
        >
          <input
            type="email"
            placeholder="yourname@gmail.com"
            className="h-12 w-full bg-black/20 dark:bg-white/20 rounded-lg px-5 font-medium placeholder:text-[#9CA3AF] sm:flex-1"
            required
          />
          <button className="bg-black dark:bg-white text-white dark:text-black h-12 rounded-lg px-5 min-w-fit">
            Get access
          </button>
        </form>
      </div>
    </div>
  );
};
