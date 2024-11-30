"use client";
import { cn } from "@/lib/utils";
import { useInView, motion } from "framer-motion";
import { useRef } from "react";

const MaskText = ({
  phrases,
  tag,
  className,
  direction,
}: {
  phrases: string[];
  tag: string;
  className?: string;
  direction?: "left" | "right" | "up" | "down";
}) => {
  const animate = {
    initial: {
      x: direction === "left" ? "-100%" : direction === "right" ? "100%" : "0%",
      y: direction === "left" ? "-100%" : direction === "right" ? "100%" : "0%",
    },
    open: (i: number) => ({
      x: 0,
      y: 0,
      transition: { duration: 1, delay: 0.1 * i, ease: [0.33, 1, 0.68, 1] },
    }),
  };
  const body = useRef(null);
  const isInView = useInView(body, { margin: "-10%", amount: 0.4 });
  return (
    <div ref={body}>
      {phrases.map((phrase, index) => {
        return (
          <div className={cn("overflow-hidden", className)} key={index}>
            {tag === "h1" ? (
              <motion.h1
                variants={animate}
                initial="initial"
                animate={isInView ? "open" : ""}
                custom={index}
              >
                {phrase}
              </motion.h1>
            ) : tag === "h2" ? (
              <motion.h2
                variants={animate}
                initial="initial"
                animate={isInView ? "open" : ""}
                custom={index}
              >
                {phrase}
              </motion.h2>
            ) : tag === "h3" ? (
              <motion.h3
                variants={animate}
                initial="initial"
                animate={isInView ? "open" : ""}
                custom={index}
              >
                {phrase}
              </motion.h3>
            ) : (
              <motion.p
                variants={animate}
                initial="initial"
                animate={isInView ? "open" : ""}
                custom={index}
              >
                {phrase}
              </motion.p>
            )}
          </div>
        );
      })}
    </div>
  );
};

export default MaskText;
